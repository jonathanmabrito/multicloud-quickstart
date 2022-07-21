module "cloudbuild" {
  source = "../../tfm/0-gcp/"
  storageBucketName = "gts-multicloud-pe-jonathan-tf-statefiles"
  location = "us-west2"
  project_id = "gts-multicloud-pe-jonathan"
  user = "serviceAccount:764772328560@cloudbuild.gserviceaccount.com"
}

provider "google" {
  project = "gts-multicloud-pe-jonathan"
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