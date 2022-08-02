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