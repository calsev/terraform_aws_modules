module "name_map" {
  source   = "../../name_map"
  name_map = local.lx_map_flattened
  std_map  = var.std_map
}

locals {
  l1_map = {
    for k_api, v_api in var.api_map : k_api => merge(v_api, {
      auth_map = v_api.auth_map == null ? var.auth_map_default : v_api.auth_map
    })
  }
  l2_map = {
    for k_api, v_api in local.l1_map : k_api => merge(v_api, {
      auth_map = {
        for k_auth, v_auth in v_api.auth_map : k_auth => merge(v_auth, {
          cognito_client_app_key = v_auth.cognito_client_app_key == null ? v_api.auth_cognito_client_app_key_default : v_auth.cognito_client_app_key
          cognito_pool_key       = v_auth.cognito_pool_key == null ? v_api.auth_cognito_pool_key_default : v_auth.cognito_pool_key
          identity_source_list   = v_auth.identity_source_list == null ? var.auth_identity_source_list_default : v_auth.identity_source_list
          lambda_key             = v_auth.lambda_key == null ? v_api.auth_lambda_key_default : v_auth.lambda_key
          k_api                  = k_api
          k_auth                 = k_auth
        })
      }
    })
  }
  l3_map = {
    for k_api, v_api in local.l2_map : k_api => merge(v_api, {
      auth_map = {
        for k_auth, v_auth in v_api.auth_map : k_auth => merge(v_auth, {
          uses_jwt     = v_auth.cognito_client_app_key != null && v_auth.cognito_client_app_key != null
          uses_request = v_auth.lambda_key != null
        })
      }
    })
  }
  l4_map = {
    for k_api, v_api in local.l3_map : k_api => merge(v_api, {
      auth_map = {
        for k_auth, v_auth in v_api.auth_map : k_auth => merge(v_auth, {
          authorization_type              = v_auth.uses_jwt ? "JWT" : v_auth.uses_request ? "REQUEST" : file("ERROR: Must provide Cognito or Lambda key")
          jwt_audience_list               = v_auth.uses_jwt ? [var.cognito_data_map[v_auth.cognito_pool_key].client_app_map[v_auth.cognito_client_app_key].client_app_id] : null
          jwt_issuer                      = v_auth.uses_jwt ? "https://${var.cognito_data_map[v_auth.cognito_pool_key].user_pool_endpoint}" : null
          request_authorizer_uri          = v_auth.uses_request ? var.lambda_data_map[v_auth.lambda_key].invoke_arn : null
          request_cache_ttl_s             = v_auth.uses_request ? v_auth.request_cache_ttl_s == null ? var.auth_request_cache_ttl_s_default : v_auth.request_cache_ttl_s : 0
          request_iam_role_arn            = v_auth.uses_request ? v_auth.request_iam_role_arn == null ? v_api.auth_request_iam_role_arn_default : v_auth.request_iam_role_arn : null
          request_payload_format_version  = v_auth.uses_request ? v_auth.request_payload_format_version == null ? var.auth_request_payload_format_version_default : v_auth.request_payload_format_version : null
          request_simple_response_enabled = v_auth.uses_request ? v_auth.request_simple_response_enabled == null ? var.auth_request_simple_response_enabled_default : v_auth.request_simple_response_enabled : null
          route_authorization_type        = v_auth.uses_jwt ? "JWT" : v_auth.uses_request ? "CUSTOM" : file("ERROR: Must provide Cognito or Lambda key")
        })
      }
    })
  }
  lx_list_flattened = flatten([
    for k_api, v_api in local.l4_map : [
      for k_auth, v_auth in v_api.auth_map : merge(
        { for k, v in v_api : k => v if !contains(["auth_map"], k) },
        v_auth
      )
    ]
  ])
  lx_map = {
    for k, v in local.lx_map_flattened : k => merge(v, module.name_map.data["${v.k_api}-${v.k_auth}"])
  }
  lx_map_flattened = {
    for v in local.lx_list_flattened : "${v.k_api}-${v.k_auth}" => v
  }
  output_data = {
    for k_api, v_api in local.l4_map : k_api => merge(
      v_api,
      {
        auth_map = {
          for k_auth, v_auth in v_api.auth_map : k_auth => merge(
            {
              for k_all, v_all in local.lx_map["${k_api}-${k_auth}"] : k_all => v_all if !contains(["k_api", "k_auth"], k_all)
            },
            {
              authorizer_id = aws_apigatewayv2_authorizer.this_auth["${k_api}-${k_auth}"].id
            },
          )
        }
      },
    )
  }
}
