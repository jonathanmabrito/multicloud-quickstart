module "pullsecret" {
    source            = "../../../tfm/3-gcp-posttasks/4-pullsecret/"
    region            = "INSERT_VGCPREGIONPRIMARY"
    project_id        = "INSERT_VGCPPROJECT"
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
    helm = {
      source = "hashicorp/helm"
      version = "2.6.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.12.1"
    }
  }

  required_version = "= 1.2.6"
}

terraform {
  backend "gcs" {
    bucket = "INSERT_VSTORAGEBUCKET"
    prefix = "docker-pullsecret"
  }
}