resource "aws_apigatewayv2_api" "this_api" {
  for_each                     = local.lx_map
  api_key_selection_expression = "$request.header.x-api-key"
  body                         = null
  cors_configuration {
    allow_credentials = each.value.cors_allow_credentials
    allow_headers     = each.value.cors_allow_headers
    allow_methods     = each.value.cors_allow_methods
    allow_origins     = each.value.cors_allow_origins
    expose_headers    = each.value.cors_expose_headers
    max_age           = each.value.cors_max_age
  }
  credentials_arn              = null # QQ
  disable_execute_api_endpoint = each.value.disable_execute_endpoint
  fail_on_warnings             = true
  name                         = each.value.name_effective
  protocol_type                = "HTTP"
  route_key                    = null # QQ
  route_selection_expression   = "$request.method $request.path"
  tags                         = each.value.tags
  target                       = null # QQ
  version                      = each.value.version
}

module "integration" {
  source  = "../../api_gateway/integration"
  api_map = local.integration_map
  std_map = var.std_map
}

module "route" {
  source  = "../../api_gateway/route"
  api_map = local.route_map
}

resource "aws_apigatewayv2_deployment" "this_deployment" {
  for_each   = local.route_map
  api_id     = each.value.api_id
  depends_on = [module.route]
  lifecycle {
    create_before_destroy = true
  }
  triggers = {
    redeployment = sha1(jsonencode(each.value))
  }
}

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

module "stage" {
  source  = "../../api_gateway/stage"
  api_map = local.stage_map
  std_map = var.std_map
}
