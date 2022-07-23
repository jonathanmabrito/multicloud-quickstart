module "jumphost_instance" {
    source          = "../../../tfm/8-PullSecret/"
    project         = "INSERT_VGCPPROJECT"
    region          = "INSERT_VGCPREGIONPRIMARY"
}

provider "google" {
  project = "INSERT_VGCPPROJECT"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.52.0"
    }
  }

  required_version = "= 1.2.5"
}

terraform {
  backend "gcs" {
    bucket = "INSERT_VSTORAGEBUCKET"
    prefix = "pullsecret-INSERT_VGCPREGIONPRIMARY-state"
  }
}