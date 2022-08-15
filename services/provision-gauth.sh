echo "***********************"
echo "Set variables"
echo "***********************"
export gkeCluster=$VGKECLUSTER
export gcpRegion=$VGCPREGION
export gcpProject=$VGCPPROJECT
export NS=gauth
export SERVICE=gauth
export DOMAIN=$VDOMAIN
export IMAGE_REGISTRY=$VIMAGEREGISTRY
export ARTIFACT_REPO=$VARTIFACTREPO
export FULLCOMMAND=$VHELMCOMMAND
export EMAIL=$VEMAILADDRESS

echo "***********************"
echo "Logging into GCP"
echo "***********************"
gcloud init --no-launch-browser

echo "***********************"
echo "Logging into GKE"
echo "***********************"
gcloud container clusters get-credentials $gkeCluster --region $gcpRegion --project $gcpProject

echo "***********************"
echo "Create or use namespace"
echo "***********************"
if ! kubectl get namespaces $NS; then
    echo "Namespace $NS does not exist. Creating it.."
    kubectl create namespace $NS
else
    echo "Namespace $NS already exists. Will use it."
fi
kubectl config set-context --current --namespace=$NS

echo "***********************"
echo "Create Docker Pull Secret"
echo "***********************"
if ! kubectl get secret pullsecret -n $NS; then
    echo "Fetching Pullsecret from Google Secrets"
    pullsecret=$(gcloud secrets versions access 1 --secret="docker-pull-secret" | base64 --decode)
    echo "$pullsecret" >> "./services/$SERVICE/key.json"
    echo "Creating Kubernetes Secret for the Pullsecret"
    kubectl create secret docker-registry pullsecret -n $NS --docker-server=$gcpRegion-docker.pkg.dev --docker-username=_json_key --docker-password="$(cat ./services/$SERVICE/key.json)" --docker-email=$EMAIL
else
    echo "Pullsecret already exists. Will use it."
fi

echo "***********************"
echo "Creating JKS Keystore"
echo "***********************"
keytool -keystore jksStorage.jks -genkey -noprompt -alias gws-auth-key -dname "CN=$DOMAIN, O=Genesys, L=Indianapolis, S=Indiana, C=US" -storepass Genesys1234 -keypass Genesys1234 -keyalg RSA
JKSBASE64=$(cat ./jksStorage.jks | base64 -w 0)
sed -i "s#JKS_KEY_CONTENT#$JKSBASE64#g" "./services/$SERVICE/01_chart_gauth/override_values.yaml"
sed -i "s#JKS_KEY_CONTENT#$JKSBASE64#g" "./services/$SERVICE/01_chart_gauth/01_release_gauth/override_values.yaml"
echo $JKSBASE64
cat "./services/$SERVICE/01_chart_gauth/override_values.yaml"

echo "***********************"
echo "Creating K8 Secrets"
echo "***********************"
REDISPASSWORD=$(kubectl get -n infra secrets infra-redis-redis-cluster -o jsonpath='{.data.redis-password}' | base64 --decode)
sed -i "s|INSERT_REDIS_PASSWORD|$REDISPASSWORD|g" "./services/$SERVICE/$SERVICE-k8secrets-deployment-secrets.yaml"

POSTGRESPASSWORD=$(kubectl get secret --namespace infra pgdb-gws-postgresql -o jsonpath="{.data.postgres-password}" | base64 --decode)
sed -i "s|INSERT_POSTGRES_PASSWORD|$POSTGRESPASSWORD|g" "./services/$SERVICE/$SERVICE-k8secrets-deployment-secrets.yaml"

GAUTH_PG_PASSWORD=$(gcloud secrets versions access 1 --secret="GAUTH_pg_password")
sed -i "s|INSERT_GAUTH_PG_PASSWORD|$GAUTH_PG_PASSWORD|g" "./services/$SERVICE/$SERVICE-k8secrets-deployment-secrets.yaml"

GAUTH_ADMIN_PASSWORD=$(gcloud secrets versions access 1 --secret="GAUTH_admin_password")
sed -i "s|INSERT_GAUTH_ADMIN_PASSWORD|$GAUTH_ADMIN_PASSWORD|g" "./services/$SERVICE/$SERVICE-k8secrets-deployment-secrets.yaml"

GAUTH_GWS_CLIENT_SECRET=$(gcloud secrets versions access 1 --secret="GAUTH_gws_client_secret")
sed -i "s|INSERT_GAUTH_GWS_CLIENT_SECRET|$GAUTH_GWS_CLIENT_SECRET|g" "./services/$SERVICE/$SERVICE-k8secrets-deployment-secrets.yaml"

GAUTH_JKS_KEYPASSWORD=$(gcloud secrets versions access 1 --secret="GAUTH_jks_keyPassword")
sed -i "s|INSERT_GAUTH_JKS_KEYPASSWORD|$GAUTH_JKS_KEYPASSWORD|g" "./services/$SERVICE/$SERVICE-k8secrets-deployment-secrets.yaml"

GAUTH_JKS_KEYSTOREPASSWORD=$(gcloud secrets versions access 1 --secret="GAUTH_jks_keyStorePassword")
sed -i "s|INSERT_JKS_KEYSTOREPASSWORD|$GAUTH_JKS_KEYSTOREPASSWORD|g" "./services/$SERVICE/$SERVICE-k8secrets-deployment-secrets.yaml"

cat "./services/$SERVICE/$SERVICE-k8secrets-deployment-secrets.yaml"

kubectl apply -f  ./services/$SERVICE/$SERVICE-k8secrets-deployment-secrets.yaml

echo "***********************"
echo "Run Helm Charts"
echo "***********************"

cd "./services/$SERVICE"
COMMAND=$(echo $FULLCOMMAND | cut -d' ' -f1)
if [[ "$FULLCOMMAND" == *" "* ]]; then
    CHART_NAME=$(echo $FULLCOMMAND | tr -s ' ' | cut -d' ' -f2)
    RL_NAME=$(echo $FULLCOMMAND | tr -s ' ' | cut -d' ' -f3)
fi

# FOR EVERY HELM CHART ############################################################
# ℹ️ Notice: in application folder should be exist subfolder with name in format: 
#      [0-9][0-9]_chart_chart-name 
# where chart-name is name of chart using to installing 
# and digits define the instalation order 
# The chart-name using in command:
#     helm install RELEASE-NAME helm-repo/chart-name
# ##################################################################################
for DIR in [0-9][0-9]_chart_*$CHART_NAME*/; do
    
    CHART=$([[ -d "$DIR" ]] && echo $DIR | sed 's/[0-9][0-9]_chart_//' | sed 's/\///')
    
    DIR=$(echo $DIR | sed 's/\///')
    
    # evaluate ENV variables
    envsubst < $DIR/override_values.yaml > overrides.yaml
    # 🖊️ (Optional) EDIT 1st line of chart.ver file with chart version number
    VER=$(head -n 1 $DIR/chart.ver)
    
    echo "Artifact repo: $ARTIFACT_REPO"
    echo "Chart: $CHART"

    FLAGS="$ARTIFACT_REPO/$CHART --install --version=$VER -n $NS -f $(pwd)/overrides.yaml"
    echo "Flags: $FLAGS"
    
    case $COMMAND in
    install)
        echo "Installing..."
        CMD="upgrade"
        ;;
    uninstall)
        echo "Uninstalling..."
        CMD="uninstall"
        FLAGS=""
        ;;
    validate)
        echo "Validating..."
        CMD="upgrade"
        FLAGS+=" --dry-run"
        ;;
    *)
        echo "❌ Wrong command"
        exit 1
        ;;
    esac
    cd $DIR
    
    touch overrides.yaml
    [[ "$FLAGS" ]] && FLAGS+=" -f $(pwd)/overrides.yaml"

    echo "Touch Override Flags: $FLAGS"
    
    # FOR EVERY HELM RELEASE###########################################################
    # ℹ️ Notice: in chart folder should be exist subfolder with name in format: 
    #      [0-9][0-9]_release_release-name 
    # where release-name is name of release using to installing 
    # and digits define the instalation order 
    # The release-name using in command:
    #     helm install release-name helm-repo/chart-name
    #
    # If you want to run some preparing script (for ex: init database, check conditions) 
    # before installing, place you code in pre-relese-script.sh in release subfolder
    #
    # If you want to run some post-installing script (for ex: validate something),
    # place you code in post-relese-script.sh in release subfolder
    # ##################################################################################
    for DIR_RL in [0-9][0-9]_release_*$RL_NAME*/; do
        RELEASE=$([[ -d "$DIR_RL" ]] && echo $DIR_RL | sed 's/[0-9][0-9]_release_//' | sed 's/\///')
        cd $DIR_RL
        # Run pre-release-script if exists
        [[ "$COMMAND" == "install" ]] && [[ -f "pre-release-script.sh" ]] \
            && source pre-release-script.sh
        cd ..
        # evaluate ENV variables
        envsubst < $DIR_RL/override_values.yaml > overrides.yaml
        echo "helm $CMD $RELEASE $FLAGS"
        [[ "$CMD" ]] && [[ "$CHART" ]] && [[ "$RELEASE" ]] && \
                    helm $CMD $RELEASE $FLAGS
        cd $DIR_RL
        # Run post-release-script if exists
        [[ "$COMMAND" == "install" ]] && [[ -f "post-release-script.sh" ]] \
            && source post-release-script.sh
        cd ..
    
    done
    cd ..
done