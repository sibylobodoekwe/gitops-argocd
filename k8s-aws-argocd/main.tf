terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 2.12.0, < 4.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.27"
    }

    kubectl = {
      source  = "hashicorp/kubectl"
      version = "1.11.0"
    }
  }
}


provider "google" {
  credentials = file("./credentials.json")
  project     = "microservice-417615"
  region      = "us-central1"

}

provider "helm" {
  kubernetes {
    host                   = module.gke_cluster.endpoint
    cluster_ca_certificate = base64decode(module.gke_cluster.master_auth.0.cluster_ca_certificate)
    token                  = module.gke_cluster.master_auth.0.access_token
  }
}

provider "kubernetes" {
  host                   = module.gke_cluster.endpoint
  cluster_ca_certificate = base64decode(module.gke_cluster.master_auth.0.cluster_ca_certificate)
  token                  = module.gke_cluster.master_auth.0.access_token
}

provider "kubectl" {
  host                   = module.gke_cluster.endpoint
  cluster_ca_certificate = base64decode(module.gke_cluster.master_auth.0.cluster_ca_certificate)
  token                  = module.gke_cluster.master_auth.0.access_token
  load_config_file       = false
}

data "google_compute_zones" "available" {}

data "google_container_cluster" "cluster" {
  name     = module.gke_cluster.name
  location = module.gke_cluster.location
}

data "google_container_cluster_auth" "cluster" {
  name     = module.gke_cluster.name
  location = module.gke_cluster.location
  provider = google
}

data "google_client_openid_userinfo" "current" {}

data "google_service_account" "current" {
  account_id = "default"
}

data "google_project" "current" {}

resource "google_project_iam_binding" "editor" {
  project = data.google_project.current.project_id
  role    = "roles/editor"

  members = [
    "serviceAccount:${data.google_service_account.current.email}",
  ]
}

data "google_dns_managed_zone" "hosted_zone" {
  name        = var.domain_name
  dns_name    = var.domain_name
  description = "Managed Zone for ${var.domain_name}"
}

data "google_dns_managed_zone" "hosted_zone_data" {
  name = var.domain_name
}

data "google_dns_record_set" "site_domain_record_set" {
  zone = google_dns_managed_zone.hosted_zone.name
  name = "microservice.${var.domain_name}"
}

data "kubernetes_service" "ingress_nginx" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "default"
  }
}

locals {
  lb_name_parts = split("-", split(".", data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.ip).0)
}

locals {
  name = join("-", slice(local.lb_name_parts, 0, length(local.lb_name_parts) - 1))
}

data "google_compute_global_forwarding_rules" "nlb" {
  name = local.name
}

data "google_client_config" "current" {}

locals {
  cluster_name = "ms-gke-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "4.0.0"

  project_id              = "microservice-417615"
  network_name            = "ms-vpc"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
  subnets = [
    {
      subnet_name      = "public-subnet"
      subnet_ip        = "10.0.4.0/24"
      region           = "us-central1-f"
      enable_flow_logs = false
    },
    {
      subnet_name      = "private-subnet"
      subnet_ip        = "10.0.1.0/24"
      region           = "us-central1-f"
      enable_flow_logs = false
    }
  ]
}

module "gke_cluster" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "30.2.0"

  name               = "microservice"
  project_id         = "microservice-417615"
  region             = "us-central1"
  network            = module.vpc.network_name
  subnetwork         = module.vpc.subnets[0].subnet_name
  ip_range_pods      = "10.0.0.0/16"
  ip_range_services  = "10.1.0.0/20"
  initial_node_count = 3
}