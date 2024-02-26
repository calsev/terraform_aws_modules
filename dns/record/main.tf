resource "aws_route53_record" "this_dns_record" {
  for_each = local.lx_map
  dynamic "alias" {
    for_each = each.value.is_alias_type ? { this = {} } : {}
    content {
      name                   = each.value.dns_alias_name                   # TODO
      zone_id                = each.value.dns_alias_zone_id                # TODO
      evaluate_target_health = each.value.dns_alias_evaluate_target_health # TODO
    }
  }
  allow_overwrite = true
  # cidr_routing_policy
  # failover_routing_policy
  # geolocation_routing_policy
  # geoproximity_routing_policy
  # latency_routing_policy
  # multivalue_answer_routing_policy
  # weighted_routing_policy
  health_check_id = null
  name            = each.value.dns_from_fqdn
  records         = each.value.dns_record_list
  set_identifier  = null
  ttl             = each.value.ttl
  type            = each.value.dns_type
  zone_id         = each.value.dns_from_zone_id
}
