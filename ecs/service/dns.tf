resource "aws_service_discovery_service" "discovery" {
  for_each = local.sd_map
  dns_config {
    dns_records {
      type = "A"
      ttl  = 300 # TODO: DRY with dns/record
    }
    namespace_id   = each.value.sd_namespace_id
    routing_policy = null
  }
  force_destroy = false
  # health_check_config # TODO
  # health_check_custom_config # TODO
  name         = each.value.sd_hostname
  namespace_id = each.value.sd_namespace_id
  tags         = each.value.tags
  type         = null
}
