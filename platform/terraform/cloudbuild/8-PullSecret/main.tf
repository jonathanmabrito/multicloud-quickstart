module "jumphost_instance" {
    source          = "../../../tfm/8-PullSecret/"
    project         = "gts-multicloud-pe-dev2"
    region          = "us-west2"
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

terraform {
  backend "gcs" {
    bucket = "gts-multicloud-pe-dev2-tf-statefiles" #Replace with the name of the bucket created above
    prefix = "pullsecret-uswest2-state" #creates a new folder
  }
}