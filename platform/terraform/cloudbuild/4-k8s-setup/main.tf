module "k8s-setup" {
    source        = "../../../tfm/4-k8s-setup/"
    project_id   = "gts-multicloud-pe-dev2"
    network_name = "network01"
    ipv4         = "10.198.12.0/22"
}

data "google_client_config" "provider" {}

data "google_container_cluster" "cluster03" {
  name = "cluster03"
  location = "us-west2"
  project = "gts-multicloud-pe-dev2"
}

provider "google" {
  project = "gts-multicloud-pe-dev2"
}

provider "kubernetes" {
  host = "https://${data.google_container_cluster.cluster03.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.cluster03.master_auth[0].cluster_ca_certificate,
  ) 
}

variable "helm_version" {
default = "v2.9.1"
}

provider "helm" {
  kubernetes {
    host = "https://${data.google_container_cluster.cluster03.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
    data.google_container_cluster.cluster03.master_auth[0].cluster_ca_certificate,
    )
    config_path = "~/.kube/config"
  } 
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
    bucket = "gts-multicloud-pe-dev2-tf-statefiles" 
    prefix = "k8s-setup-cluster03-uswest2-state" #creates a new folder
  }
}