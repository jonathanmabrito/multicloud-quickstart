module "cloudbuild" {
  source = "../../tfm/0-cloudbuild/"
  storageBucketName = "gts-multicloud-pe-dev-tf-statefiles"
  location = "us-west2"
  project_id = "gts-multicloud-pe-dev"
  user = "serviceAccount:729705515652@cloudbuild.gserviceaccount.com"
}

provider "google" {
  project = "gts-multicloud-pe-dev"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.52.0"
    }
  }

  required_version = "= 1.0.11"
}