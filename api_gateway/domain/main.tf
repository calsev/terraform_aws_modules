resource "aws_apigatewayv2_domain_name" "this_domain" {
  for_each    = local.domain_map
  domain_name = each.key
  domain_name_configuration {
    certificate_arn                        = var.dns_data.region_domain_cert_map[var.std_map.aws_region_name][each.key].arn
    endpoint_type                          = "REGIONAL"
    ownership_verification_certificate_arn = null # Private cert
    security_policy                        = "TLS_1_2"
  }
  # mutual_tls_authentication Trust store
  tags = each.value.tags
}

resource "aws_route53_record" "this_dns_alias" {
  for_each = local.domain_map
  alias {
    evaluate_target_health = false
    name                   = aws_apigatewayv2_domain_name.this_domain[each.key].domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.this_domain[each.key].domain_name_configuration[0].hosted_zone_id
  }
  name    = "${each.key}."
  type    = "A"
  zone_id = var.dns_data.domain_to_dns_zone_map[each.value.validation_domain].dns_zone_id
}
