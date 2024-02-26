resource "aws_service_discovery_public_dns_namespace" "this_namespace" {
  for_each = local.lx_map
  name     = each.key
  tags     = each.value.tags
}

data "aws_route53_zone" "this_zone" {
  for_each = local.lx_map
  zone_id  = aws_service_discovery_public_dns_namespace.this_namespace[each.key].hosted_zone
}

module "this_ns" {
  source                           = "../../dns/record"
  dns_data                         = var.dns_data
  record_dns_from_zone_key_default = var.zone_dns_from_zone_key_default
  record_dns_type_default          = "NS"
  record_map                       = local.create_ns_map
  std_map                          = var.std_map
}
