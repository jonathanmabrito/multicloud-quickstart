module "jumphost_instance" {
    source                = "../../../tfm/9-repo/"
    project               = "INSERT_VGCPPROJECT"
    consultoken           = "INSERT_CONSUL_TOKEN"
}

terraform {
      required_providers {
        consul = {
          source = "hashicorp/consul"
          version = "2.15.1"
        }
        google = {
          source  = "hashicorp/google"
          version = "4.29.0"
        }
      }

  required_version = "= 1.2.5"
}

provider "google" {
  project = "INSERT_VGCPPROJECT"
}

provider "consul" {
  address    = "localhost:8500"
  datacenter = "dc1"
  token      = var.consultoken
}

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