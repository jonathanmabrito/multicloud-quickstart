module "cloudbuild" {
  source = "../../tfm/1-cloudbuild/"
  project_id = "gts-multicloud-pe-dev"
  gkeregionprimary = "us-west2"
  gkeregionsecondary = "us-east1"
  gkecluster = "cluster02"
  fqdn = "cluster02.gcp.demo.genesys.com"
  emailaddress = "jonathan.mabrito@genesys.com"
  storageBucketName = "gts-multicloud-pe-dev-tf-statefiles"
}

provider "google" {
  project = "gts-multicloud-pe-dev"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.29.0"
    }
  }

  required_version = "= 1.0.11"
}

terraform {
  backend "gcs" {
    bucket = "gts-multicloud-pe-dev-tf-statefiles" #Replace with the name of the bucket created above
    prefix = "base-state" #creates a new folder
  }
}