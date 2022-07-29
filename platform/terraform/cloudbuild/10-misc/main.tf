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
