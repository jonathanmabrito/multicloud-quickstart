module "cloudbuild" {
  source = "../../tfm/0-cloudbuild/"
  storageBucketName = "gts-multicloud-pe-dev2-tf-statefiles"
  location = "us-west2"
}

provider "google" {
  project = "gts-multicloud-pe-dev2"
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