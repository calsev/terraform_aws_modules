resource "aws_service_discovery_service" "discovery" {
  for_each = local.dns_map
  dns_config {
    namespace_id = each.value.sd_namespace_id
    dns_records {
      type = "A"
      ttl  = var.ttl_dns_a
    }
  }
  name         = each.value.public_dns_name
  namespace_id = each.value.sd_namespace_id
  tags         = each.value.tags
}
