# Create a managed zone in Google Cloud DNS
resource "google_dns_managed_zone" "hosted_zone" {
  name        = var.domain_name
  dns_name    = var.domain_name
  description = "Managed Zone for ${var.domain_name}"
}

# Create a record set in Google Cloud DNS
resource "google_dns_record_set" "site_domain" {
  managed_zone = google_dns_managed_zone.hosted_zone.name
  name         = "microservice.${var.domain_name}."
  type         = "A"
  ttl          = 300
  rrdatas      = [data.google_compute_global_address.lb_ip_address]
}
