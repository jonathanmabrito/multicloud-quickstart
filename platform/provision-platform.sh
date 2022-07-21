echo "***********************"
echo "Modifying Terraform Files for user variables and inputs"
echo "***********************"
#ALL UNIQUE INPUTS
#INPUT: project name
#INPUT: regions (primary and secondary)
#INPUT: FQDN
#INPUT: Cluster Name
#INPUT: Email Address

echo "***********************"
echo "Modifying 2-network"
echo "***********************"
#INPUT: project name
#INPUT: regions (primary and secondary)
#INPUT: FQDN

echo "***********************"
echo "Modifying 3-gke-cluster"
echo "***********************"
#INPUT: project name
#INPUT: regions (primary)
#INPUT: Cluster Name

echo "***********************"
echo "Modifying 4-k8s-setup"
echo "***********************"
#INPUT: project name
#INPUT: region (primary)
#INPUT: Cluster Name


echo "***********************"
echo "Modifying 5-certs"
echo "***********************"
#INPUT: project name
#INPUT: region (primary)
#INPUT: Cluster Name
#INPUT: FQDN
#INPUT: Email Address

echo "***********************"
echo "Modifying 6-thirdparty"
echo "***********************"
#INPUT: project name
#INPUT: region (primary)
#INPUT: Cluster Name

echo "***********************"
echo "Modifying 7-jumphost"
echo "***********************"
#INPUT: project name
#INPUT: region (primary)
#INPUT: Cluster Name

echo "***********************"
echo "Modifying 8-PullSecret"
echo "***********************"
#INPUT: project name
#INPUT: region (primary)
#INPUT: Cluster Name

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