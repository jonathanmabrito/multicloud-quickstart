module "pe-secrets_instance" {
    source           = "../../../tfm/1-prereqs/3-pe-secrets/"
    region           = "INSERT_PRIMARYREGION"
    GAUTH_POSTGRES_PASSWORD = ""
    GAUTH_gauth_pg_password = ""
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
    prefix = "pe-secrets"
  }
}