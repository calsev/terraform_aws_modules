module "cert" {
  source     = "../cert"
  dns_data   = var.dns_data
  domain_map = local.domain_map
  std_map    = var.std_map
}

resource "aws_apigatewayv2_domain_name" "this_domain" {
  for_each    = local.domain_map
  domain_name = each.key
  domain_name_configuration {
    certificate_arn = module.cert.data[each.key].arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
  tags = each.value.tags
}

resource "aws_route53_record" "this_dns_alias" {
  for_each = local.domain_map
  alias {
    # TODO: Map to stages; api key happens to match right now
    name                   = aws_apigatewayv2_domain_name.this_domain[each.key].domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.this_domain[each.key].domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
  name    = "${each.key}."
  type    = "A"
  zone_id = var.dns_data.domain_to_dns_zone_map[each.value.validation_domain].dns_zone_id
}
