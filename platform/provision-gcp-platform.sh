echo "***********************"
echo "Modifying Terraform Files for user variables and inputs"
echo "***********************"
#ALL UNIQUE INPUTS
#INPUT: VGCPPROJECT
#INPUT: VGCPREGIONPRIMARY
#INPUT: VGCPREGIONSECONDARY
#INPUT: VDOMAIN
#INPUT: VGKECLUSTER
#INPUT: VEMAILADDRESS
#INPUT: VSTORAGEBUCKET

echo "***********************"
echo "Modifying 2-network"
echo "***********************"
#INPUT: VGCPPROJECT
#INPUT: VGCPREGIONPRIMARY
#INPUT: VGCPREGIONSECONDARY
#INPUT: VDOMAIN
#INPUT: VSTORAGEBUCKET

sed -i "s#INSERT_VGCPPROJECT#$VGCPPROJECT#g" "./platform/terraform/cloudbuild/2-network/main.tf"
sed -i "s#INSERT_VGCPREGIONPRIMARY#$VGCPREGIONPRIMARY#g" "./platform/terraform/cloudbuild/2-network/main.tf"
sed -i "s#INSERT_VGCPREGIONSECONDARY#$VGCPREGIONSECONDARY#g" "./platform/terraform/cloudbuild/2-network/main.tf"
sed -i "s#INSERT_VDOMAIN#$VDOMAIN#g" "./platform/terraform/cloudbuild/2-network/main.tf"
sed -i "s#INSERT_VSTORAGEBUCKET#$VSTORAGEBUCKET#g" "./platform/terraform/cloudbuild/2-network/main.tf"
cat "./platform/terraform/cloudbuild/2-network/main.tf"

echo "***********************"
echo "Modifying 3-gke-cluster"
echo "***********************"
#INPUT: VGCPPROJECT
#INPUT: VGCPREGIONPRIMARY
#INPUT: VGKECLUSTER
#INPUT: VSTORAGEBUCKET

sed -i "s#INSERT_VGCPPROJECT#$VGCPPROJECT#g" "./platform/terraform/cloudbuild/3-gke-cluster/main.tf"
sed -i "s#INSERT_VGCPREGIONPRIMARY#$VGCPREGIONPRIMARY#g" "./platform/terraform/cloudbuild/3-gke-cluster/main.tf"
sed -i "s#INSERT_VGKECLUSTER#$VGKECLUSTER#g" "./platform/terraform/cloudbuild/3-gke-cluster/main.tf"
sed -i "s#INSERT_VSTORAGEBUCKET#$VSTORAGEBUCKET#g" "./platform/terraform/cloudbuild/3-gke-cluster/main.tf"
cat "./platform/terraform/cloudbuild/3-gke-cluster/main.tf"

echo "***********************"
echo "Modifying 4-k8s-setup"
echo "***********************"
#INPUT: VGCPPROJECT
#INPUT: VGCPREGIONPRIMARY
#INPUT: VGKECLUSTER
#INPUT: VSTORAGEBUCKET

sed -i "s#INSERT_VGCPPROJECT#$VGCPPROJECT#g" "./platform/terraform/cloudbuild/4-k8s-setup/main.tf"
sed -i "s#INSERT_VGCPREGIONPRIMARY#$VGCPREGIONPRIMARY#g" "./platform/terraform/cloudbuild/4-k8s-setup/main.tf"
sed -i "s#INSERT_VGKECLUSTER#$VGKECLUSTER#g" "./platform/terraform/cloudbuild/4-k8s-setup/main.tf"
sed -i "s#INSERT_VSTORAGEBUCKET#$VSTORAGEBUCKET#g" "./platform/terraform/cloudbuild/4-k8s-setup/main.tf"
cat "./platform/terraform/cloudbuild/4-k8s-setup/main.tf"

echo "***********************"
echo "Modifying 5-certs"
echo "***********************"
#INPUT: VGCPPROJECT
#INPUT: VGCPREGIONPRIMARY
#INPUT: VGKECLUSTER
#INPUT: VDOMAIN
#INPUT: VEMAILADDRESS
#INPUT: VSTORAGEBUCKET

sed -i "s#INSERT_VGCPPROJECT#$VGCPPROJECT#g" "./platform/terraform/cloudbuild/5-certs/main.tf"
sed -i "s#INSERT_VGCPREGIONPRIMARY#$VGCPREGIONPRIMARY#g" "./platform/terraform/cloudbuild/5-certs/main.tf"
sed -i "s#INSERT_VGKECLUSTER#$VGKECLUSTER#g" "./platform/terraform/cloudbuild/5-certs/main.tf"
sed -i "s#INSERT_VDOMAIN#$VDOMAIN#g" "./platform/terraform/cloudbuild/5-certs/main.tf"
sed -i "s#INSERT_VEMAILADDRESS#$VEMAILADDRESS#g" "./platform/terraform/cloudbuild/5-certs/main.tf"
sed -i "s#INSERT_VSTORAGEBUCKET#$VSTORAGEBUCKET#g" "./platform/terraform/cloudbuild/5-certs/main.tf"
cat "./platform/terraform/cloudbuild/5-certs/main.tf"

echo "***********************"
echo "Modifying 6-thirdparty"
echo "***********************"
#INPUT: VGCPPROJECT
#INPUT: VGCPREGIONPRIMARY
#INPUT: VGKECLUSTER
#INPUT: VSTORAGEBUCKET

sed -i "s#INSERT_VGCPPROJECT#$VGCPPROJECT#g" "./platform/terraform/cloudbuild/6-thirdparty/main.tf"
sed -i "s#INSERT_VGCPREGIONPRIMARY#$VGCPREGIONPRIMARY#g" "./platform/terraform/cloudbuild/6-thirdparty/main.tf"
sed -i "s#INSERT_VGKECLUSTER#$VGKECLUSTER#g" "./platform/terraform/cloudbuild/6-thirdparty/main.tf"
sed -i "s#INSERT_VSTORAGEBUCKET#$VSTORAGEBUCKET#g" "./platform/terraform/cloudbuild/6-thirdparty/main.tf"
cat "./platform/terraform/cloudbuild/6-thirdparty/main.tf"

echo "***********************"
echo "Modifying 7-jumphost"
echo "***********************"
#INPUT: VGCPPROJECT
#INPUT: VGCPREGIONPRIMARY
#INPUT: VGKECLUSTER
#INPUT: VSTORAGEBUCKET

sed -i "s#INSERT_VGCPPROJECT#$VGCPPROJECT#g" "./platform/terraform/cloudbuild/7-jumphost/main.tf"
sed -i "s#INSERT_VGCPREGIONPRIMARY#$VGCPREGIONPRIMARY#g" "./platform/terraform/cloudbuild/7-jumphost/main.tf"
sed -i "s#INSERT_VGKECLUSTER#$VGKECLUSTER#g" "./platform/terraform/cloudbuild/7-jumphost/main.tf"
sed -i "s#INSERT_VSTORAGEBUCKET#$VSTORAGEBUCKET#g" "./platform/terraform/cloudbuild/7-jumphost/main.tf"
cat "./platform/terraform/cloudbuild/7-jumphost/main.tf"

echo "***********************"
echo "Modifying 8-PullSecret"
echo "***********************"
#INPUT: VGCPPROJECT
#INPUT: VGCPREGIONPRIMARY
#INPUT: VGKECLUSTER
#INPUT: VSTORAGEBUCKET

sed -i "s#INSERT_VGCPPROJECT#$VGCPPROJECT#g" "./platform/terraform/cloudbuild/8-PullSecret/main.tf"
sed -i "s#INSERT_VGCPREGIONPRIMARY#$VGCPREGIONPRIMARY#g" "./platform/terraform/cloudbuild/8-PullSecret/main.tf"
sed -i "s#INSERT_VGKECLUSTER#$VGKECLUSTER#g" "./platform/terraform/cloudbuild/8-PullSecret/main.tf"
sed -i "s#INSERT_VSTORAGEBUCKET#$VSTORAGEBUCKET#g" "./platform/terraform/cloudbuild/8-PullSecret/main.tf"
cat "./platform/terraform/cloudbuild/8-PullSecret/main.tf"

echo "***********************"
echo "Initializing Terraform to provision GCP Platform"
echo "***********************"
for dir in platform/terraform/cloudbuild/*
do 
    cd ${dir}   
    env=${dir%*/}
    env=${env#*/}  
    echo ""
    echo "*************** TERRAFOM PLAN ******************"
    echo "******* At environment: ${env} ********"
    echo "*************************************************"
    terraform init || exit 1
    cd ../../../../
done

echo "***********************"
echo "Executing Terraform to provision GCP Platform"
echo "***********************"
for dir in platform/terraform/cloudbuild/*
do 
    cd ${dir}   
    env=${dir%*/}
    env=${env#*/}  
    echo ""
    echo "*************** TERRAFOM PLAN ******************"
    echo "******* At environment: ${env} ********"
    echo "*************************************************"
    terraform apply -auto-approve || exit 1
    cd ../../../../
done

echo "***********************"
echo "Enable Filestore"
echo "***********************"
gkeClusterStatus=$(gcloud container clusters list --format="value(STATUS.scope())")
echo $gkeClusterStatus

gcloud container clusters update $VGKECLUSTER --update-addons=GcpFilestoreCsiDriver=ENABLED --region=$VGCPREGIONPRIMARY