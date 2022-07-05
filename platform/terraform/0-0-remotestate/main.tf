module "remote_state" {
  source      = "../../tfm/0-remotestate/"
  name        = "gts-multicloud-pe-dev-tf-statefiles"
  location    = "us-west1" 
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