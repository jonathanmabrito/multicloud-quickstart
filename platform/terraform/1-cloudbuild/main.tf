module "cloudbuild" {
  source = "../../tfm/1-cloudbuild/"
  project_id = "gts-multicloud-pe-jonathan"
}

provider "google" {
  project = "gts-multicloud-pe-jonathan"
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.29.0"
    }
  }

  required_version = "= 1.0.11"
}

terraform {
  backend "gcs" {
    bucket = "gts-multicloud-pe-jonathan-tf-statefiles" #Replace with the name of the bucket created above
    prefix = "base-state" #creates a new folder
  }
}