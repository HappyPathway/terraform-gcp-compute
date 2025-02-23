terraform {
  required_version = ">= 1.0.0"
}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  version                    = "~> 25.0"
  project_id                 = var.project_id
  name                       = "${var.project_id}-gke"
  region                     = var.region
  network                    = data.terraform_remote_state.networking.outputs.vpc_network_name
  subnetwork                 = data.terraform_remote_state.networking.outputs.subnet_name
  ip_range_pods             = "pods"
  ip_range_services         = "services"
  
  // Basic cluster configuration
  regional                  = true
  create_service_account    = false
  remove_default_node_pool  = true
  initial_node_count       = 1

  // Security settings
  grant_registry_access     = true
  master_authorized_networks_config = [
    {
      cidr_blocks = [
        {
          cidr_block   = "10.0.0.0/24"
          display_name = "VPN"
        }
      ]
    }
  ]

  // Node pool configuration
  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "e2-standard-4"
      min_count         = 1
      max_count         = 5
      disk_size_gb      = 100
      disk_type         = "pd-standard"
      image_type        = "COS_CONTAINERD"
      auto_repair       = true
      auto_upgrade      = true
      service_account   = google_service_account.gke_sa.email
    }
  ]

  // Private cluster settings
  network_policy          = true
  http_load_balancing    = true
  private_cluster_config = {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block = "172.16.0.0/28"
  }
}

resource "google_service_account" "gke_sa" {
  account_id   = "gke-service-account"
  display_name = "GKE Service Account"
  project      = var.project_id
}

data "terraform_remote_state" "networking" {
  backend = "gcs"
  config = {
    bucket = "tf-state-gcp-kubernetes"
    prefix = "terraform/state/networking"
  }
}