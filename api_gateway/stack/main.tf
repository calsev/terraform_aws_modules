module "api" {
  source                               = "../../api_gateway/api"
  api_cors_allow_credentials_default   = var.api_cors_allow_credentials_default
  api_cors_allow_headers_default       = var.api_cors_allow_headers_default
  api_cors_allow_methods_default       = var.api_cors_allow_methods_default
  api_cors_allow_origins_default       = var.api_cors_allow_origins_default
  api_cors_expose_headers_default      = var.api_cors_expose_headers_default
  api_cors_max_age_default             = var.api_cors_max_age_default
  api_disable_execute_endpoint_default = var.api_disable_execute_endpoint_default
  api_map                              = local.lx_map
  api_name_infix_default               = var.api_name_infix_default
  api_version_default                  = var.api_version_default
  std_map                              = var.std_map
}

module "auth" {
  source           = "../../api_gateway/authorizer"
  api_map          = local.integration_map
  auth_map_default = var.api_auth_map_default
  cognito_data_map = var.cognito_data_map
  lambda_data_map  = var.lambda_data_map
  std_map          = var.std_map
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

module "domain" {
  source                           = "../../api_gateway/domain"
  dns_data                         = var.dns_data
  domain_map                       = var.domain_map
  domain_validation_domain_default = var.domain_validation_domain_default
  std_map                          = var.std_map
}

module "stage" {
  source  = "../../api_gateway/stage"
  api_map = local.stage_map
  std_map = var.std_map
}
