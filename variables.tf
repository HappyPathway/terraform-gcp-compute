variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for resource deployment"
  type        = string
}

output "gke_service_account" {
  value = google_service_account.gke_sa.name
}

output "cluster_name" {
  value = module.gke.name
}

output "gke_instance_group" {
  value = module.gke.instance_group_urls[0]
}
