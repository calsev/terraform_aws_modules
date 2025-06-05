resource "aws_apigatewayv2_api" "this_api" {
  for_each                     = local.lx_map
  api_key_selection_expression = "$request.header.x-api-key"
  body                         = null
  dynamic "cors_configuration" {
    for_each = each.value.cors_enabled ? { this = {} } : {}
    content {
      allow_credentials = each.value.cors_allow_credentials
      allow_headers     = each.value.cors_allow_headers
      allow_methods     = each.value.cors_allow_methods
      allow_origins     = each.value.cors_allow_origins
      expose_headers    = each.value.cors_expose_headers
      max_age           = each.value.cors_max_age
    }
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
