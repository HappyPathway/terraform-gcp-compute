# Compute & Application Module

## Overview
This module provisions the Google Kubernetes Engine (GKE) cluster and related resources.

## Resources Created
- **GKE Cluster**
- **Node Pools**
- **Autoscaling Configuration**

## Inputs
- `project_id` - GCP Project ID
- `region` - Deployment region
- `gke_cluster_name` - Name of the GKE Cluster
- `node_count` - Number of nodes in the pool
- `machine_type` - Machine type for the nodes
- `enable_autoscaling` - Boolean to enable autoscaling

## Outputs
- `gke_cluster_endpoint` - Endpoint for the GKE cluster
- `node_pool_names` - Names of the node pools

## Usage Example
```hcl
module "compute" {
  source            = "./modules/compute"
  project_id        = "my-gcp-project"
  region            = "us-central1"
  gke_cluster_name  = "terraform-ai-cluster"
  node_count        = 3
  machine_type      = "e2-standard-4"
  enable_autoscaling = true
}
```

## Best Practices
- Use **Autopilot mode** for reduced operational overhead.
- Enable **node auto-repair** and **auto-upgrade**.
- Restrict public access using **private clusters**.