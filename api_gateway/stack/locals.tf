module "api_name_map" {
  source                = "../../name_map"
  name_infix_default    = var.api_name_infix_default
  name_map              = local.l0_map
  name_regex_allow_list = ["."]
  std_map               = var.std_map
}

module "domain_name_map" {
  source             = "../../name_map"
  name_infix_default = false
  name_map           = var.domain_map
  std_map            = var.std_map
}

locals {
  auth_map = {
    for k_api, v_api in local.integration_map : k_api => merge(v_api, {
      auth_map = {
        for k_auth, v_auth in v_api.auth_map : k_auth => merge(v_auth, {
          jwt_audience_list = [var.cognito_data_map[v_auth.cognito_pool_key].client_app_map[v_auth.cognito_client_app_key].client_app_id]
          jwt_issuer        = "https://${var.cognito_data_map[v_auth.cognito_pool_key].user_pool_endpoint}"
        })
      }
    })
  }
  domain_map = {
    for k, v in var.domain_map : k => merge(v, module.domain_name_map.data[k], {
      validation_domain = v.validation_domain == null ? var.domain_validation_domain_default : v.validation_domain
    })
  }
  integration_map = {
    for k_api, v_api in local.lx_map : k_api => merge(v_api, {
      api_id = aws_apigatewayv2_api.this_api[k_api].id
    })
  }
  l0_map = {
    for k, v in var.api_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.api_name_map.data[k], {
      auth_map                 = v.auth_map == null ? var.api_auth_map_default : v.auth_map
      cors_allow_credentials   = v.cors_allow_credentials == null ? var.api_cors_allow_credentials_default : v.cors_allow_credentials
      cors_allow_headers       = v.cors_allow_headers == null ? var.api_cors_allow_headers_default : v.cors_allow_headers
      cors_allow_methods       = v.cors_allow_methods == null ? var.api_cors_allow_methods_default : v.cors_allow_methods
      cors_allow_origins       = v.cors_allow_origins == null ? var.api_cors_allow_origins_default : v.cors_allow_origins
      cors_expose_headers      = v.cors_expose_headers == null ? var.api_cors_expose_headers_default : v.cors_expose_headers
      cors_max_age             = v.cors_max_age == null ? var.api_cors_max_age_default : v.cors_max_age
      disable_execute_endpoint = v.disable_execute_endpoint == null ? var.api_disable_execute_endpoint_default : v.disable_execute_endpoint
      enable_dns_mapping       = lookup(var.domain_map, k, null) != null
      version                  = v.version == null ? var.api_version_default : v.version
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      auth_map = {
        for k_auth, v_auth in local.l1_map[k].auth_map : k_auth => merge(v_auth, {
          cognito_client_app_key = v_auth.cognito_client_app_key == null ? var.api_cognito_client_app_key_default : v_auth.cognito_client_app_key
          cognito_pool_key       = v_auth.cognito_pool_key == null ? var.api_auth_cognito_pool_key_default : v_auth.cognito_pool_key
        })
      }
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    api_map = {
      for k_api, v_api in local.lx_map : k_api => merge(
        {
          for k, v in v_api : k => v if !contains(["auth_map", "integration_map", "stage_map"], k)
        },
        {
          api_arn           = aws_apigatewayv2_api.this_api[k_api].arn
          api_endpoint      = aws_apigatewayv2_api.this_api[k_api].api_endpoint
          api_execution_arn = aws_apigatewayv2_api.this_api[k_api].execution_arn
          api_id            = aws_apigatewayv2_api.this_api[k_api].id
          auth_map = {
            for k_auth, v_auth in v_api.auth_map : k_auth => merge(v_auth, module.auth.data[k_api].auth_map[k_auth])
          }
          deployment_id = aws_apigatewayv2_deployment.this_deployment[k_api].id
          integration_map = {
            for k_int, v_int in v_api.integration_map : k_int => merge(
              {
                for k, v in v_int : k => v if !contains(["route_map"], k)
              },
              module.integration.data[k_api][k_int],
              module.route.data[k_api][k_int],
            )
          }
          stage_map = {
            for k_stage, v_stage in v_api.stage_map : k_stage => merge(
              v_stage,
              module.stage.data[k_api][k_stage],
            )
          }
        }
      )
    }
    domain_map = local.domain_map
  }
  route_map = {
    for k_api, v_api in local.integration_map : k_api => merge(v_api, {
      integration_map = {
        for k_int, v_int in v_api.integration_map : k_int => merge(v_int, {
          integration_id = module.integration.data[k_api][k_int].id
          route_map = v_int.route_map != null ? v_int.route_map : {
            "${v_api.integration_route_method_default} /${k_int}" = {
              authorization_scopes = null
              authorization_type   = null
              authorizer_id        = null
              operation_name       = null
            }
          }
        })
      }
    })
  }
  stage_map = {
    for k_api, v_api in local.route_map : k_api => merge(v_api, {
      deployment_id  = aws_apigatewayv2_deployment.this_deployment[k_api].id
      domain_name_id = aws_apigatewayv2_domain_name.this_domain[k_api].id
    })
  }
}
