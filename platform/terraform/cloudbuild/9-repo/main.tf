module "jumphost_instance" {
    source          = "../../../tfm/9-repo/"
    project         = "INSERT_VGCPPROJECT"
    region          = "INSERT_VGCPREGIONPRIMARY"
    repoid          = "INSERT_VGCPREPOID"
    repoexists      = "INSERT_REPOEXISTS"
}

provider "google" {
  project = "INSERT_VGCPPROJECT"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.29.0"
    }
  }

  required_version = "= 1.2.5"
}

/* terraform {
  backend "gcs" {
    bucket = "INSERT_VSTORAGEBUCKET"
    prefix = "repo-INSERT_VGCPREGION-state"
  }
} */