resource "aws_apigatewayv2_api" "this_api" {
  for_each                     = local.api_map
  api_key_selection_expression = "$request.header.x-api-key"
  #body
  cors_configuration {
    allow_credentials = each.value.cors_configuration.allow_credentials
    allow_headers     = each.value.cors_configuration.allow_headers
    allow_methods     = each.value.cors_configuration.allow_methods
    allow_origins     = each.value.cors_configuration.allow_origins
    expose_headers    = each.value.cors_configuration.expose_headers
    max_age           = each.value.cors_configuration.max_age
  }
  #credentials_arn
  fail_on_warnings = true
  name             = each.value.name_effective
  protocol_type    = "HTTP"
  #route_key
  route_selection_expression = "$request.method $request.path"
  tags                       = each.value.tags
  #target
  version = each.value.version
}

module "integration" {
  source                      = "../api_gateway_integration"
  api_map                     = local.integration_map
  integration_subtype_default = "step_function"
  std_map                     = var.std_map
}

module "route" {
  source  = "../api_gateway_route"
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

module "stage" {
  source  = "../api_gateway_stage"
  api_map = local.stage_map
  std_map = var.std_map
}
