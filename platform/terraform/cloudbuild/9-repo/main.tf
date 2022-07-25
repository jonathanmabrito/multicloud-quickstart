module "jumphost_instance" {
    source                = "../../../tfm/9-repo/"
    project               = "INSERT_VGCPPROJECT"
    region                = "INSERT_VGCPREGIONPRIMARY"
    repoid                = "INSERT_VGCPREPOID"
    repoexists            = "INSERT_REPOEXISTS"
    remoteregistry        = "INSERT_REMOTEREPO"
    remoteregistry_user   = "INSERT_REMOTEREPOUID"
    remoteregistry_pass   = "INSERT_REMOTEREPOPWD"
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