resource "aws_apigatewayv2_authorizer" "this_auth" {
  for_each                          = local.lx_map
  api_id                            = each.value.api_id
  authorizer_credentials_arn        = each.value.request_iam_role_arn
  authorizer_payload_format_version = each.value.request_payload_format_version
  authorizer_result_ttl_in_seconds  = each.value.request_cache_ttl_s
  authorizer_type                   = each.value.authorizer_type
  authorizer_uri                    = each.value.request_authorizer_uri
  enable_simple_responses           = each.value.request_simple_response_enabled
  identity_sources                  = each.value.identity_source_list
  dynamic "jwt_configuration" {
    for_each = each.value.uses_jwt ? { this = {} } : {}
    content {
      audience = each.value.jwt_audience_list
      issuer   = each.value.jwt_issuer
    }
  }
  name = each.value.name_effective
}
