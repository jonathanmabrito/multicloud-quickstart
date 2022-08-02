# Summary
The steps outlined in this ReadMe will prepare the GCP project with the necessary Google API enablement, CloudBuild triggers. and Google Secrets.

The steps outlined in this ReadMe are the only steps that need to be manually executed from your local workstation. Once these procedures are complete, Cloud Build is setup to take over and run the rest of the Terraform and Helm Charts automatically. 

#Procedure

## Install Terraform
If its not already installed on your local workstation, go ahead and install Terraform from [HashiCorp](https://www.terraform.io/downloads)

## Install Google Cloud CLI
If its not already install on your local workstation, go ahead and install the Google Cloud CLI package from [Google](https://cloud.google.com/sdk/docs/install)

## Clone the repo
Clone this repo to your local workstation if its not already. 

## Log into Google Cloud
Log into your Google Cloud account and project. 

```
gcloud auth login

gcloud config set project PROJECT_NAME
```

## Update Terraform variables and inputs with GCP and environment information
The "main.tf" files within the "platform/terraform/1-prereqs" directory and sub-folders will need to be updated to your proper GCP and environmental information

1.) Update "platform/terraform/1-prereqs/1-gcp/main.tf"

- storageBucket (replace INSERT_STORAGEBUCKETNAME instances) - name of the Cloud Storage bucket to store the Terraform state files
- location (replace INSERT_LOCATION instances) - the primary GCP region/location (us-west-2 for example) where the GCP services are going to be stood up in
- project_id and project (replace INSERT_PROJECTNAME instances) - the GCP project logical name (do not use the Project Number!)
- user (replace INSERT_SERVICEACCOUNT instances) - the service account that will be used for Cloud Build jobs. This will be the project number of the GCP project (not the logical name). Only update the "INSERT_SERVICEACCOUNT" piece, as the rest of the schema defined below for this value is needed: serviceAccount:projectNumber@cloudbuild.gserviceaccount.com

```
module "gcp" {
  source = "../../tfm/1-prereqs/1-gcp/"
  storageBucketName = "INSERT_STORAGEBUCKETNAME"
  location = "INSERT_LOCATION"
  project_id = "INSERT_PROJECTNAME"
  user = "serviceAccount:INSERT_SERVICEACCOUNT@cloudbuild.gserviceaccount.com"
}

provider "google" {
  project = "INSERT_PROJECTNAME"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.29.0"
    }
  }

  required_version = "= 1.2.6"
}
```

Within your terminal, set the directory to "/platform/terraform/1-prereqs/1-gcp" and then run the following commands:

```
terraform init

terraform apply
```

The Cloud Build API sometimes takes a few to fully initialize. The Terraform job may error out with a "Error 400: Request contains an invalid argument." message. If this happens, wait a few minutes and re-run "Terraform Apply" and it should run successfully. 

2.) Authenticate Github to Cloud Build
The Terraform files in the previous step, enables the necessary Google API's against the chosen Google Cloud project, including the Cloud Build API. The Github account where this repository is cloned to will need to be authenticated with Cloud Build before the next steps can continue. Please follow the Cloud Build documentation to set up the necessary authentication: https://cloud.google.com/build/docs/automating-builds/github/connect-repo-github


3.) Update "platform/terraform/1-prereqs/2-cloudbuild/main.tf"
Before continuing onto this step, make sure you authenticated Github to Cloud Build. This procedure is outlined in step 2 and very important to have been completed before continuing. 

- project_id and project (replace INSERT_PROJECTNAME instances) - the GCP project logically name
- gkeregionprimary (replace INSERT_PRIMARYREGION instances) - the primary GCP region/location where the GCP services are going to be stood up in
- gkeregionsecondary (replace INSERT_SECONDARYEGION instances) - the secondary GCP region/location where the GCP services potentially can be stood up in)
- gkecluster (replace INSERT_GKECLUSTERNAME instances) - the name that be given to the GKE cluster
- fqdn (replace INSERT_FQDN instances) - the root FQDN that will be used for DNS. Every MultiCloud Private Edition service will be use this FQDN and create a subdomain address off of it. For example, the FQDN of "domain.com" is assigned. When GAUTH is stood up, its URL will be "gauth.domain.com" and a certficate is assigned by Cert-Manager. This FQDN assigned here will need to be a public domain. 
- emailaddress (replace INSERT_EMAILADDRESS instances) - The emaill address of an administrator. This is assigned to the Cloud DNS service that is stood up. 
- storageBucketName (replace INSERT_STORAGEBUCKETNAME instances) - name of the Cloud Storage bucket to store the Terraform state files. This MUST be the same value from "1-prereqs" 
- githubURL (replace INSERT_GITHUBURL instances) - The URL containing the cloned repository
- helmRepoURL (replace INSERT_HELMURL) - The URL/Connection string for the Helm Charts. If Google Artifact registry is going to be used, then the follow schema is used: oci://us-west2-docker.pkg.dev/PROJECT_NAME/genesys-multicloud-pe
- containerRegistryURL (replace INSERT_CONTAINERURL) - The URL for the Container Registry storing the MultiCloud Private Edition images. If Google Artifact registry is going to be used,then the following schema is used: gcr.io/PROJECT_NAME/genesys-multicloud-pe
- repoid (INSERT_ARTIFCTORYURL) - 
- remotehelm (INSERT_ARTIFCTORYHELMPATH) - URL of the Artifactory repo of Genesys MultiCloud Private Edition containers hosted by Genesys
- remoterepo (INSERT_ARTIFCTORYHELMPATH) - HELM Repo path within the Artifactory instance by Genesys
- remoteuser (INSERT_ARTIFACTORYUSER) - username for the Artifactory account
- remotepass (INSERT_ARTIFACTORYPASSWORD) - password for the Artifactory account


```
module "cloudbuild" {
  source = "../../tfm/1-prereqs/2-cloudbuild/"
  project_id = "INSERT_PROJECTNAME"
  gkeregionprimary = "INSERT_PRIMARYREGION"
  gkeregionsecondary = "INSERT_SECONDARYREGION"
  gkecluster = "INSERT_GKECLUSTERNAME"
  fqdn = "INSERT_EMAILADDRESS"
  emailaddress = "INSERT_EMAILADDRESS"
  storageBucketName = "INSERT_STORAGEBUCKETNAME"
  githubURL = "INSERT_GITHUBURL"
  helmRepoURL = "oci://us-west2-docker.pkg.dev/INSERT_PROJECTNAME/genesys-multicloud-pe"
  containerRegistryURL = "gcr.io/INSERT_PROJECTNAME/genesys-multicloud-pe"
  repoid = "genesys-multicloud-pe"
  remotehelm = "https://pureengageuse1.jfrog.io/artifactory/api/helm/helm-multicloud" 
  remoterepo = "pureengageuse1-docker-multicloud.jfrog.io"
  remoteuser = "demo-user"
  remotepass = "Genesys1"
}

provider "google" {
  project = "INSERT_PROJECTNAME"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.29.0"
    }
  }

  required_version = "= 1.2.6"
}

terraform {
  backend "gcs" {
    bucket = "INSERT_STORAGEBUCKETNAME"
    prefix = "base-state"
  }
}
```

Within your terminal, set the directory to "/platform/terraform/1-prereqs/2-cloudbuild" and then run the following commands:

```
terraform init

terraform apply
```

4.) Update "platform/terraform/1-prereqs/3-pe-secrets/main.tf"
THIS SECTION IS VERY IMPORTANT....PLEASE TAKE YOUR TIME HERE. 

Throughout the provisioning process of the MultiCloud Private Edition stack, various credentials are created such as Database Accounts, API clients, etc. The Helm charts in this repository will create a pre-defined username, but the passwords that are used are to be set and created here.

- project_id and project (replace INSERT_PROJECTNAME instances) - the GCP project logically name
- gkeregionprimary (replace INSERT_PRIMARYREGION instances) - the primary GCP region/location where the GCP services are going to be stood up in

```
module "pe-secrets_instance" {
    source           = "../../../tfm/1-prereqs/3-pe-secrets/"
    region           = "INSERT_PRIMARYREGION"
    gauth_pg_password = ""
}

provider "google" {
  project = "INSERT_PROJECTNAME"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.29.0"
    }
  }

  required_version = "= 1.2.6"
}

terraform {
  backend "gcs" {
    bucket = "INSERT_STORAGEBUCKETNAME"
    prefix = "pe-secrets"
  }
}
```

Within your terminal, set the directory to "/platform/terraform/1-prereqs/3-pe-secrets" and then run the following commands:

```
terraform init

terraform apply
```

5.) Create PrivateEdition Cloud Build Builder image
Before the rest of the GCP platform can be provisioned with Terraform and the MultiCloud Private Edition Helm Charts can be executed, a custom Cloud Build builder image needs to be created. This image will contain the necessary tools, SDK's, etc to perform the rest of the provisioning tasks. 

A CloudBuild trigger is created called "0-Create-PrivateEdition-Builder" is created. Please run this Cloud Build job to create the necessary Builder image. 