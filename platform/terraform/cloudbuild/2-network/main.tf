module "network" {
    source          = "../../../tfm/2-network/"
    provision_vpc   = true
    project_id      = "gts-multicloud-pe-dev2"
    network_name    = "network01"
    environment     = "gts-multicloud-pe-dev2" #For naming conventions; can be the same as project name.
    region          = ["us-west2","us-east1"]
    fqdn            = "cluster03.gcp.demo.genesys.com."

    subnets = [
        {
            subnet_name           = "enviroment01-us-west2-subnet"
            subnet_ip             = "10.198.0.0/22"
            subnet_region         = "us-west2"
        },
        {
            subnet_name           = "enviroment01-us-west2-vm-subnet"
            subnet_ip             = "10.198.8.0/22"
            subnet_region         = "us-west2"
        },
        {
            subnet_name           = "enviroment01-us-west2-privateep-subnet"
            subnet_ip             = "10.198.4.0/22"
            subnet_region         = "us-west2"
        },
         {
            subnet_name           = "enviroment01-us-east1-subnet"
            subnet_ip             = "10.200.0.0/22"
            subnet_region         = "us-east1"
        },
        {
            subnet_name           = "enviroment01-us-east1-vm-subnet"
            subnet_ip             = "10.200.8.0/22"
            subnet_region         = "us-east1"
        },
        {
            subnet_name           = "enviroment01-us-east1-privateep-subnet"
            subnet_ip             = "10.200.4.0/22"
            subnet_region         = "us-east1"
        }
    ]
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
    prefix = "network-state" #creates a new folder
  }
}