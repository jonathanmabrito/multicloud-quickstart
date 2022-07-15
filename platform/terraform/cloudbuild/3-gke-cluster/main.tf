module "gke" {
    source                  = "../../../tfm/3-gke-cluster/"
    project_id              = "gts-multicloud-pe-dev2"
    environment             = "enviroment01"
    network_name            = "network01"
    region                  = "us-west2"
    cluster                 = "cluster03"
    gke_version             = "1.22.10-gke.600" #Minumum version supported: 1.22.*
    release_channel         = "STABLE" 
    secondary_pod_range     = "10.198.64.0/18"
    secondary_service_range = "10.198.16.0/20"
    gke_num_nodes           = "2"
    windows_node_pool       = false
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
        prefix = "gke-cluster-cluster03-uswest2-state" #creates a new folder
    }
}