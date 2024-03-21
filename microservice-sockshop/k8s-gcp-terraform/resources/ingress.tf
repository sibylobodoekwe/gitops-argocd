# resource "google_compute_global_forwarding_rule" "microservice_cluster_ingress_forwarding_rule" {
#   name       = "microservice-cluster-ingress-forwarding-rule"
#   target     = google_compute_target_http_proxy.microservice_cluster_ingress_http_proxy.self_link
#   port_range = "80"
# }

# resource "google_compute_target_http_proxy" "microservice_cluster_ingress_http_proxy" {
#   name    = "microservice-cluster-ingress-http-proxy"
#   url_map = google_compute_url_map.microservice_cluster_ingress_url_map.self_link
# }

# resource "google_compute_url_map" "microservice_cluster_ingress_url_map" {
#   name            = "microservice-cluster-ingress-url-map"
#   default_service = google_compute_backend_service.microservice_cluster_ingress_backend_service.self_link
# }

# resource "google_compute_backend_service" "microservice_cluster_ingress_backend_service" {
#   name = "microservice-cluster-ingress-backend-service"
#   backend {
#     group = google_container_cluster.microservice_cluster.instance_group_urls[0]
#   }
# }
