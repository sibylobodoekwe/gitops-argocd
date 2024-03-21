variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}

resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.primary.name}-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]

    labels = {
      env = var.project_id
    }

    machine_type = "n1-standard-1"
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

# variable "gke_username" {
#   default     = ""
#   description = "gke username"
# }

# variable "gke_password" {
#   default     = ""
#   description = "gke password"
# }

# variable "gke_num_nodes" {
#   default     = 2
#   description = "number of gke nodes"
# }

# locals {
#   cluster_name = "${var.project_id}-gke"
#   node_count   = 2
#   machine_type = "n1-standard-1"
# }

# resource "google_container_cluster" "primary" {
#   name               = local.cluster_name
#   location           = var.zone
#   initial_node_count = local.node_count

#   network    = google_compute_network.vpc.name
#   subnetwork = google_compute_subnetwork.subnet.name

#   remove_default_node_pool = true

#   node_config {
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/logging.write",
#       "https://www.googleapis.com/auth/monitoring",
#       "https://www.googleapis.com/auth/devstorage.read_only",
#     ]

#     labels = {
#       env = var.project_id
#     }

#     machine_type = local.machine_type
#     tags         = ["gke-node", local.cluster_name]
#     metadata = {
#       disable-legacy-endpoints = "true"
#     }

#     service_account = google_service_account.gke_service_account.email
#   }
# }

# resource "google_service_account" "gke_service_account" {
#   account_id   = "gke-service-account"
#   display_name = "GKE Service Account"
# }


# resource "google_container_node_pool" "primary_nodes" {
#   name       = "${google_container_cluster.primary.name}-node-pool"
#   location   = var.zone
#   cluster    = google_container_cluster.primary.name
#   node_count = var.gke_num_nodes

#   node_config {
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/logging.write",
#       "https://www.googleapis.com/auth/monitoring",
#       "https://www.googleapis.com/auth/devstorage.read_only",
#     ]

#     labels = {
#       env = var.project_id
#     }

#     machine_type = "n1-standard-1"
#     tags         = ["gke-node", "${var.project_id}-gke"]
#     metadata = {
#       disable-legacy-endpoints = "true"
#     }
#   }
# }