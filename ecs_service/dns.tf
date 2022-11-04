resource "aws_service_discovery_service" "discovery" {
  for_each = var.public_dns_name != null ? { this = {} } : {}
  dns_config {
    namespace_id = var.sd_namespace_id
    dns_records {
      type = "A"
      ttl  = var.ttl_dns_a
    }
  }
  name         = var.public_dns_name
  namespace_id = var.sd_namespace_id
  tags         = local.tags
}
