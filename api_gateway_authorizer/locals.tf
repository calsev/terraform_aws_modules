module "name_map" {
  source   = "../name_map"
  name_map = local.l0_map
  std_map  = var.std_map
}

locals {
  l0_map = {
    for k, v in var.auth_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      api_id                          = v.api_id == null ? var.auth_api_id_default : v.api_id
      authorizer_type                 = v.authorizer_type == null ? var.auth_authorizer_type_default : v.authorizer_type
      identity_source_list            = v.identity_source_list == null ? var.auth_identity_source_list_default : v.identity_source_list
      jwt_audience_list               = v.jwt_audience_list == null ? var.auth_jwt_audience_list_default : v.jwt_audience_list
      jwt_issuer                      = v.jwt_issuer == null ? var.auth_jwt_issuer_default : v.jwt_issuer
      request_authorizer_uri          = v.request_authorizer_uri == null ? var.auth_request_authorizer_uri_default : v.request_authorizer_uri
      request_cache_ttl_s             = v.request_cache_ttl_s == null ? var.auth_request_cache_ttl_s_default : v.request_cache_ttl_s
      request_iam_role_arn            = v.request_iam_role_arn == null ? var.auth_request_iam_role_arn_default : v.request_iam_role_arn
      request_payload_format_version  = v.request_payload_format_version == null ? var.auth_request_payload_format_version_default : v.request_payload_format_version
      request_simple_response_enabled = v.request_simple_response_enabled == null ? var.auth_request_simple_response_enabled_default : v.request_simple_response_enabled
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      uses_jwt = local.l1_map[k].authorizer_type == "JWT"
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        id = aws_apigatewayv2_authorizer.this_auth[k].id
      }
    )
  }
}
