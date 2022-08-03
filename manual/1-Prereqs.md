# Summary
The steps outlined below will prepare the GCP project with the necessary Google API enablement, CloudBuild triggers, and Google Secrets. These are the only steps that need to be manually executed from your local workstation. Once these procedures are complete, Cloud Build is setup to take over and run the rest of the Terraform and Helm Charts automatically. 

## Install Terraform
If its not already installed on your local workstation, go ahead and install Terraform from [HashiCorp](https://www.terraform.io/downloads)

## Install Google Cloud CLI
If its not already install on your local workstation, go ahead and install the Google Cloud CLI package from [Google](https://cloud.google.com/sdk/docs/install)

## Clone the repo
Clone this repo to your local workstation if its not already. 

## Log into Google Cloud
Log into your Google Cloud account and set the project. 

```
gcloud auth login

gcloud config set project PROJECT_NAME
```

## Update Terraform variables and inputs with GCP and environment information
The "main.tf" file within the "platform/terraform/1-prereqs" directory and sub-folders will need to be updated with your GCP and environment information

### 1.) Update "platform/terraform/1-prereqs/1-gcp/main.tf"

| main.tf Variable | Value to replace | Description |
| ----------- | ----------- | ----------- |
| storageBucketName | INSERT_STORAGEBUCKETNAME | Name of the Cloud Storage bucket to store the Terraform state files |
| location | INSERT_LOCATION | The primary GCP region. To get a list of all possible regions, please refer to this [GCP Document](https://cloud.google.com/compute/docs/regions-zones/viewing-regions-zones) |
| project_id | INSERT_PROJECTNAME | The logical name of the GCP project (do not use the Project Number) |
| project | INSERT_PROJECTNAME | The logical name of the GCP project (do not use the Project Number) |
| user   | INSERT_SERVICEACCOUNT | The service account that will be used to execute the Cloud Build triggers |

```
module "gcp" {
  source = "../../../tfm/1-prereqs/1-gcp/"
  storageBucketName = "INSERT_STORAGEBUCKETNAME"
  location = "INSERT_LOCATION"
  project_id = "INSERT_PROJECTNAME"
  user = "serviceAccount:INSERT_SERVICEACCOUNT@cloudbuild.gserviceaccount.com"
}

provider "google" {
  project = ""INSERT_PROJECTNAME"
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

**NOTICE**

The Cloud Build API sometimes takes a few to fully initialize, even after Terraform says its completed and enabled it. This Terraform job may error out with a "Error 400: Request contains an invalid argument." message. If this happens, wait a few minutes and re-run "Terraform Apply" and it should run successfully. 

### 2.) Authenticate Github to Cloud Build
The Terraform logic in the previous step, enables the necessary Google API's against the chosen Google Cloud project, including the Cloud Build API. The Github account where this repository is cloned too will need to be authenticated with Cloud Build before the next steps can continue. Please follow the Cloud Build documentation to set up the necessary authentication: https://cloud.google.com/build/docs/automating-builds/github/connect-repo-github


### 3.) Update "platform/terraform/1-prereqs/2-cloudbuild/main.tf"

**NOTICE**

Before continuing onto this step, make sure you authenticated Github to Cloud Build. This procedure is outlined in step 2 and very important to have been completed before continuing. 

| main.tf Variable | Value to replace | Description |
| ----------- | ----------- | ----------- |
| project_id | INSERT_PROJECTNAME | The logical name of the GCP project (do not use the Project Number) |
| project | INSERT_PROJECTNAME | The logical name of the GCP project (do not use the Project Number) |
| gkeregionprimary | INSERT_PRIMARYREGION | The primary GCP region. To get a list of all possible regions, please refer to this [GCP Document](https://cloud.google.com/compute/docs/regions-zones/viewing-regions-zones) |
| gkeregionsecondary | INSERT_SECONDARYEGION | The secondary GCP region. To get a list of all possible regions, please refer to this [GCP Document](https://cloud.google.com/compute/docs/regions-zones/viewing-regions-zones) |
| gkecluster | INSERT_GKECLUSTERNAME | The name of the GKE cluster | 
| FQDN | INSERT_FQDN | The root FQDN that will be used for DNS. Every MultiCloud Private Edition service will use this FQDN and create a subdomain address off of it. For example, the FQDN of "domain.com" is assigned as the value. When GAUTH is stood up, it's URL will be "gauth.domain.com" and a certficate is assigned by Cert-Manager. |
| emailaddress | INSERT_EMAILADDRESS | The email address of an administrater to assign to the Cloud DNS service that is provisioned | 
|  storageBucketName | INSERT_STORAGEBUCKETNAME | Name of the Cloud Storage bucket to store the Terraform state files. This MUST be the same value from "1-prereqs" | 
| bucket | INSERT_STORAGEBUCKETNAME | Name of the Cloud Storage bucket to store the Terraform state files. This MUST be the same value from "1-prereqs" | 
| githubURL | INSERT_GITHUBURL | The Github URL containing the cloned repository | 
| helmRepoURL | INSERT_HELMURL | The URL/Connection string for the Helm Charts. If Google Artifact registry is going to be used, then the follow schema is used: oci://GCP_REGION-docker.pkg.dev/PROJECT_NAME/genesys-multicloud-pe | 
| containerRegistryURL | INSERT_CONTAINERURL | The URL for the Container Registry storing the MultiCloud Private Edition images. If Google Artifact registry is going to be used,then the following schema is used: gcr.io/PROJECT_NAME/genesys-multicloud-pe
| repoid | INSERT_HELMREPOID | Folder/Directory to store the Helm Charts |
| remotehelm | INSERT_ARTIFCTORYURL | The FQDN url of the Genesys JFROG Artifactory repository. Example: https://pureengageuse1.jfrog.io/artifactory/api/helm/helm-multicloud | 
| remoterepo | INSERT_ARTIFCTORYHELMPATH | The url to the images and charts inside the Genesys JFROG Artifactory repository. Example: pureengageuse1-docker-multicloud.jfrog.io | 
| remoteuser | INSERT_ARTIFACTORYUSER | The username granted for the Genesys JFROG Artifactory Account | 
| remotepass | INSERT_ARTIFACTORYPASSWORD | The password granted for the Genesys JFROG Artifactory Account | 


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
  repoid = "INSERT_HELMREPOID"
  remotehelm = "INSERT_ARTIFCTORYURL" 
  remoterepo = "INSERT_ARTIFCTORYHELMPATH"
  remoteuser = "INSERT_ARTIFACTORYUSER"
  remotepass = "INSERT_ARTIFACTORYPASSWORD"
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

### 4.) Update "platform/terraform/1-prereqs/3-pe-secrets/main.tf"
**NOTICE**

**THIS SECTION IS VERY IMPORTANT....PLEASE TAKE YOUR TIME HERE!**

Throughout the provisioning process of the MultiCloud Private Edition stack, various credentials are created such as Database Accounts, API clients, etc. The Helm charts in this repository will create a pre-defined username, but the passwords that will be used are defined here.

| main.tf Variable | Value to replace | Description |
| ----------- | ----------- | ----------- |
| project | INSERT_PROJECTNAME | The logical name of the GCP project (do not use the Project Number) |
| region | INSERT_PRIMARYREGION | The primary GCP region. To get a list of all possible regions, please refer to this [GCP Document](https://cloud.google.com/compute/docs/regions-zones/viewing-regions-zones) |
| bucket | INSERT_STORAGEBUCKETNAME | Name of the Cloud Storage bucket to store the Terraform state files. This MUST be the same value from "1-prereqs" |
| gauth_pg_password | | Password for the GAUTH Postgres Database | 


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

### 5.) Create PrivateEdition Cloud Build Builder image
Before the rest of the GCP platform can be provisioned, a custom Cloud Build builder image needs to be created. This image will contain the necessary tools, SDK's, etc to perform the rest of the provisioning tasks. 

A CloudBuild trigger is created called "0-Create-PrivateEdition-Builder" is created. Please run this Cloud Build job to create the necessary Builder image. 

### 6.) DNS Considerations and Delegation
The Terraform logic in future steps will setup Google Cloud DNS and create a wildcard entry A record entry with value of "*.PROVIDED_FQDN" for the MultiCloud applications. As the MultiCloud Services are spun up and if they require external access, then the wildcard entry will be used to provide DNS resolution. Also Cert-Manager will use this entry for the ACME challenge when provisioning a certificate for the service.