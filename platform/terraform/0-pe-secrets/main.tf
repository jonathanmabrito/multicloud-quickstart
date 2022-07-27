module "pe-secrets_instance" {
    source          = "../../../tfm/0-pe-secrets/"
    project         = "INSERT_VGCPPROJECT"
    region          = "INSERT_VGCPREGIONPRIMARY"
    gauth_pg_password = "Genesys1234"
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
    prefix = "pe-secrets-INSERT_VGCPREGIONPRIMARY-state"
  }
}