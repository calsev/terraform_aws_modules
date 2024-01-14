module "name_map" {
  source   = "../../name_map"
  name_map = local.lx_map_flattened
  std_map  = var.std_map
}

locals {
  l1_map = {
    for k_api, v_api in var.api_map : k_api => merge(v_api, {
      api_id = v_api.api_id == null ? var.auth_api_id_default : v_api.api_id
      auth_map = {
        for k_auth, v_auth in v_api.auth_map : k_auth => merge(v_auth, {
          authorizer_type      = v_auth.authorizer_type == null ? var.auth_authorizer_type_default : v_auth.authorizer_type
          identity_source_list = v_auth.identity_source_list == null ? var.auth_identity_source_list_default : v_auth.identity_source_list
          jwt_audience_list    = v_auth.jwt_audience_list == null ? var.auth_jwt_audience_list_default : v_auth.jwt_audience_list
          jwt_issuer           = v_auth.jwt_issuer == null ? var.auth_jwt_issuer_default : v_auth.jwt_issuer
          k_api                = k_api
          k_auth               = k_auth
        })
      }
    })
  }
  l2_map = {
    for k_api, v_api in local.l1_map : k_api => merge(v_api, {
      auth_map = {
        for k_auth, v_auth in v_api.auth_map : k_auth => merge(v_auth, {
          uses_jwt = v_auth.authorizer_type == "JWT"
        })
      }
    })
  }
  l3_map = {
    for k_api, v_api in local.l2_map : k_api => merge(v_api, {
      auth_map = {
        for k_auth, v_auth in v_api.auth_map : k_auth => merge(v_auth, {
          request_authorizer_uri          = v_auth.uses_jwt ? null : v_auth.request_authorizer_uri == null ? var.auth_request_authorizer_uri_default : v_auth.request_authorizer_uri
          request_cache_ttl_s             = v_auth.uses_jwt ? 0 : v_auth.request_cache_ttl_s == null ? var.auth_request_cache_ttl_s_default : v_auth.request_cache_ttl_s
          request_iam_role_arn            = v_auth.request_iam_role_arn == null ? var.auth_request_iam_role_arn_default : v_auth.request_iam_role_arn
          request_payload_format_version  = v_auth.uses_jwt ? null : v_auth.request_payload_format_version == null ? var.auth_request_payload_format_version_default : v_auth.request_payload_format_version
          request_simple_response_enabled = v_auth.uses_jwt ? null : v_auth.request_simple_response_enabled == null ? var.auth_request_simple_response_enabled_default : v_auth.request_simple_response_enabled
        })
      }
    })
  }
  lx_list_flattened = flatten([
    for k, v in local.l3_map : [
      for k_auth, v_auth in v.auth_map : merge(v, v_auth)
    ]
  ])
  lx_map = {
    for k, v in local.lx_map_flattened : k => merge(v, module.name_map.data["${v.k_api}-${v.k_auth}"])
  }
  lx_map_flattened = {
    for v in local.lx_list_flattened : "${v.k_api}-${v.k_auth}" => v
  }
  output_data = {
    for k_api, v_api in local.l3_map : k_api => merge(
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
