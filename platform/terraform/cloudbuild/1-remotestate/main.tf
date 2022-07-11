module "cloudbuild" {
  source = "../../../tfm/1-remotestate/"
  project_id = "gts-multicloud-pe-dev2"
  user = "serviceAccount:24743425028@cloudbuild.gserviceaccount.com"
}

terraform {
  backend "gcs" {
    bucket = "gts-multicloud-pe-dev2-tf-statefiles" #Replace with the name of the bucket created above
    prefix = "base-state" #creates a new folder
  }
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