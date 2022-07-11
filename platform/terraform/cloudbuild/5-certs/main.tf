module "gke_auth" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  project_id    = "gts-multicloud-pe-dev2"
  cluster_name  = "cluster03"
  location      = "us-west2"
}

resource "local_file" "kubeconfig" {
  content  = module.gke_auth.kubeconfig_raw
  filename = "${path.module}/kubeconfig"
}

module "ingress_certs" {
  source            = "../../../tfm/5-ingress-certs/"
  project_id        = "gts-multicloud-pe-dev2"
  environment       = "gts-multicloud-pe-dev2" #same value as in 1-network
  domain_name_nginx = "nlb02-uswest2.cluster03.gcp.demo.genesys.com" #domain.example.com should be same as FQDN in module 1-network
  email             = "jonathan.mabrito@genesys.com"
}

#Kubernetes

data "google_client_config" "provider" {}

data "google_container_cluster" "cluster03" {
  name = "cluster03"
  location = "us-west2"
  project = "gts-multicloud-pe-dev2"
}

provider "kubernetes" {
  host = "https://${data.google_container_cluster.cluster03.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.cluster03.master_auth[0].cluster_ca_certificate,
  ) 
}

#Helm

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
    config_path = "${path.module}/kubeconfig"
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

terraform {
  backend "gcs" {
    bucket = "gts-multicloud-pe-dev2-tf-statefiles" #Replace with the name of the bucket created above
    prefix = "ingress-certs-cluster03-uswest2-state" #creates a new folder
  }
}