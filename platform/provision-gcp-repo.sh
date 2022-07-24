echo "***********************"
echo "Modifying Terraform Files for user variables and inputs"
echo "***********************"
#ALL UNIQUE INPUTS
#INPUT: VGCPPROJECT
#INPUT: VGCPREGIONPRIMARY
#INPUT: VGCPREPOID

echo "***********************"
echo "Modifying 9-repo"
echo "***********************"
#INPUT: VGCPPROJECT
#INPUT: VGCPREGIONPRIMARY
#INPUT: VGCPREPOID

sed -i "s#INSERT_VGCPPROJECT#$VGCPPROJECT#g" "./platform/terraform/cloudbuild/9-repo/main.tf"
sed -i "s#INSERT_VGCPREGIONPRIMARY#$VGCPREGIONPRIMARY#g" "./platform/terraform/cloudbuild/9-repo/main.tf"
sed -i "s#INSERT_VGCPREPOID#$VGCPREPOID#g" "./platform/terraform/cloudbuild/9-repo/main.tf"
cat "./platform/terraform/cloudbuild/9-repo/main.tf"

dir=platform/terraform/cloudbuild/9-repo/

echo "***********************"
echo "Initializing Terraform to provision GCP Artifactory"
echo "***********************"
#for dir in platform/terraform/cloudbuild/*
#do 
    cd ${dir}   
    env=${dir%*/}
    env=${env#*/}  
    echo ""
    echo "*************** TERRAFOM PLAN ******************"
    echo "******* At environment: ${env} ********"
    echo "*************************************************"
    terraform init || exit 1
    cd ../../../../
#done

echo "***********************"
echo "Executing Terraform to provision GCP Artifactory"
echo "***********************"
#for dir in platform/terraform/cloudbuild/*
#do 
    cd ${dir}   
    env=${dir%*/}
    env=${env#*/}  
    echo ""
    echo "*************** TERRAFOM PLAN ******************"
    echo "******* At environment: ${env} ********"
    echo "*************************************************"
    terraform apply -auto-approve || exit 1
    cd ../../../../
#done