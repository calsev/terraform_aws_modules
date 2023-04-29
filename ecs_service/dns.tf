resource "aws_service_discovery_service" "discovery" {
  for_each = local.dns_map
  dns_config {
    dns_records {
      type = "A"
      ttl  = var.dns_data.ttl_map.alias
    }
    namespace_id   = each.value.sd_namespace_id
    routing_policy = null
  }
  force_destroy = false
  # health_check_config # TODO
  # health_check_custom_config # TODO
  name         = each.value.public_dns_name
  namespace_id = each.value.sd_namespace_id
  tags         = each.value.tags
  type         = null
}
