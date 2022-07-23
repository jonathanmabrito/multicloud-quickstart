module "jumphost_instance" {
    source          = "../../../tfm/7-jumphost/"
    project         = "INSERT_VGCPPROJECT"
    name            = "INSERT_VGKECLUSTER-jumphost"
    machine_type    = "e2-micro"
    zone            = "INSERT_VGCPREGIONPRIMARY-a" 
    image           = "ubuntu-os-cloud/ubuntu-1804-lts"    
    network         = "network01"
    subnetwork      = "enviroment01-INSERT_VGCPREGIONPRIMARY-vm-subnet"
    provision_ssh_firewall = false
    provision_iap_firewall = false   
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
    prefix = "jumphost-INSERT_VGCPREGIONPRIMARY-state"
  }
}