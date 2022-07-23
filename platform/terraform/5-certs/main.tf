module "gke_auth" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  project_id    = "INSERT_VGCPPROJECT"
  cluster_name  = "INSERT_VGKECLUSTER"
  location      = "INSERT_VGCPREGIONPRIMARY"
}

resource "local_file" "kubeconfig" {
  content  = module.gke_auth.kubeconfig_raw
  filename = "${path.module}/kubeconfig"
}

module "ingress_certs" {
  source            = "../../../tfm/5-ingress-certs/"
  project_id        = "INSERT_VGCPPROJECT"
  environment       = "INSERT_VGCPPROJECT"
  domain_name_nginx = "nlb02-INSERT_VGCPREGIONPRIMARY.INSERT_VDOMAIN"
  email             = "INSERT_VEMAILADDRESS"
}

#Kubernetes

data "google_client_config" "provider" {}

data "google_container_cluster" "INSERT_VGKECLUSTER" {
  name = "INSERT_VGKECLUSTER"
  location = "INSERT_VGCPREGIONPRIMARY"
  project = "INSERT_VGCPPROJECT"
}

provider "kubernetes" {
  host = "https://${data.google_container_cluster.INSERT_VGKECLUSTER.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.INSERT_VGKECLUSTER.master_auth[0].cluster_ca_certificate,
  ) 
}

#Helm

variable "helm_version" {
default = "v2.9.1"
}

provider "helm" {
  kubernetes {
    host = "https://${data.google_container_cluster.INSERT_VGKECLUSTER.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
    data.google_container_cluster.INSERT_VGKECLUSTER.master_auth[0].cluster_ca_certificate,
    )
    config_path = "${path.module}/kubeconfig"
  }
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
    prefix = "ingress-certs-INSERT_VGKECLUSTER-INSERT_VGCPREGIONPRIMARY-state"
  }
}