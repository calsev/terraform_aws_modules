module "api_name_map" {
  source                = "../name_map"
  name_infix_default    = var.api_name_infix_default
  name_map              = var.api_map
  name_regex_allow_list = ["."]
  std_map               = var.std_map
}

module "domain_name_map" {
  source             = "../name_map"
  name_infix_default = false
  name_map           = var.domain_map
  std_map            = var.std_map
}

locals {
  api_map = {
    for k, v in var.api_map : k => merge(v, module.api_name_map.data[k], {
      cors_configuration = {
        allow_credentials = v.cors_allow_credentials == null ? var.api_cors_allow_credentials_default : v.cors_allow_credentials
        allow_headers     = v.cors_allow_headers == null ? var.api_cors_allow_headers_default : v.cors_allow_headers
        allow_methods     = v.cors_allow_methods == null ? var.api_cors_allow_methods_default : v.cors_allow_methods
        allow_origins     = v.cors_allow_origins == null ? var.api_cors_allow_origins_default : v.cors_allow_origins
        expose_headers    = v.cors_expose_headers == null ? var.api_cors_expose_headers_default : v.cors_expose_headers
        max_age           = v.cors_max_age == null ? var.api_cors_max_age_default : v.cors_max_age
      }
      version = v.version == null ? var.api_version_default : v.version
    })
  }
  domain_map = {
    for k, v in var.domain_map : k => merge(v, module.domain_name_map.data[k], {
      validation_domain = v.validation_domain == null ? var.domain_validation_domain_default : v.validation_domain
    })
  }
  integration_map = {
    for k_api, v_api in local.api_map : k_api => merge(v_api, {
      api_id = aws_apigatewayv2_api.this_api[k_api].id
    })
  }
  output_data = {
    api = {
      for k_api, v_api in local.api_map : k_api => merge(
        {
          for k, v in v_api : k => v if !contains(["integration_map", "stage_map"], k)
        },
        {
          api_endpoint  = aws_apigatewayv2_api.this_api[k_api].api_endpoint
          arn           = aws_apigatewayv2_api.this_api[k_api].arn
          deployment    = aws_apigatewayv2_deployment.this_deployment[k_api].id
          execution_arn = aws_apigatewayv2_api.this_api[k_api].execution_arn
          id            = aws_apigatewayv2_api.this_api[k_api].id
          integration = {
            for k_int, v_int in v_api.integration_map : k_int => merge(
              {
                for k, v in v_int : k => v if !contains(["route_map"], k)
              },
              module.integration.data[k_api][k_int],
              {
                route = module.route.data[k_api][k_int]
              },
            )
          }
          stage = {
            for k_stage, v_stage in v_api.stage_map : k_stage => merge(
              v_stage,
              module.stage.data[k_api][k_stage],
            )
          }
        }
      )
    }
    domain = local.domain_map
    cert   = module.cert.data
  }
  route_map = {
    for k_api, v_api in local.integration_map : k_api => merge(v_api, {
      integration_map = {
        for k_int, v_int in v_api.integration_map : k_int => merge(v_int, {
          integration_id = module.integration.data[k_api][k_int].id
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
