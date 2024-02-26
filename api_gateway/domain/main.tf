resource "aws_apigatewayv2_domain_name" "this_domain" {
  for_each    = local.lx_map
  domain_name = each.value.name_simple
  domain_name_configuration {
    certificate_arn                        = each.value.certificate_arn
    endpoint_type                          = "REGIONAL"
    ownership_verification_certificate_arn = null # Private cert
    security_policy                        = "TLS_1_2"
  }
  # mutual_tls_authentication Trust store
  tags = each.value.tags
}

module "this_dns_alias" {
  source                           = "../../dns/record"
  dns_data                         = var.dns_data
  record_dns_from_zone_key_default = var.domain_dns_from_zone_key_default
  record_map                       = local.create_alias_map
  std_map                          = var.std_map
}
