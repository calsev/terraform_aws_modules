module "name_map" {
  source                = "../../name_map"
  name_infix_default    = var.api_name_infix_default
  name_map              = local.l0_map
  name_regex_allow_list = ["."]
  std_map               = var.std_map
}

locals {
  l0_map = {
    for k, v in var.api_map : k => v
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      cors_allow_credentials   = v.cors_allow_credentials == null ? var.api_cors_allow_credentials_default : v.cors_allow_credentials
      cors_allow_headers       = v.cors_allow_headers == null ? var.api_cors_allow_headers_default : v.cors_allow_headers
      cors_allow_methods       = v.cors_allow_methods == null ? var.api_cors_allow_methods_default : v.cors_allow_methods
      cors_allow_origins       = v.cors_allow_origins == null ? var.api_cors_allow_origins_default : v.cors_allow_origins
      cors_expose_headers      = v.cors_expose_headers == null ? var.api_cors_expose_headers_default : v.cors_expose_headers
      cors_max_age             = v.cors_max_age == null ? var.api_cors_max_age_default : v.cors_max_age
      disable_execute_endpoint = v.disable_execute_endpoint == null ? var.api_disable_execute_endpoint_default : v.disable_execute_endpoint
      version                  = v.version == null ? var.api_version_default : v.version
    })
  }
  output_data = {
    for k_api, v_api in local.lx_map : k_api => merge(
      v_api,
      {
        api_arn           = aws_apigatewayv2_api.this_api[k_api].arn
        api_endpoint      = aws_apigatewayv2_api.this_api[k_api].api_endpoint
        api_execution_arn = aws_apigatewayv2_api.this_api[k_api].execution_arn
        api_id            = aws_apigatewayv2_api.this_api[k_api].id
      }
    )
  }
}
