resource "aws_service_discovery_public_dns_namespace" "this_namespace" {
  for_each = local.zone_map
  name     = each.key
  tags     = each.value.tags
}

data "aws_route53_zone" "this_zone" {
  for_each = local.zone_map
  zone_id  = aws_service_discovery_public_dns_namespace.this_namespace[each.key].hosted_zone
}

resource "aws_route53_record" "this_ns" {
  for_each = local.zone_map
  name     = "${each.key}."
  records  = data.aws_route53_zone.this_zone[each.key].name_servers
  ttl      = var.ttl_map.ns
  type     = "NS"
  zone_id  = each.value.dns_zone_id_parent
}
