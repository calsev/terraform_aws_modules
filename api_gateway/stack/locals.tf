locals {
  integration_map = {
    for k_api, v_api in local.lx_map : k_api => merge(v_api, {
      api_id = module.api.data[k_api].api_id
    })
  }
  lx_map = {
    for k, v in var.api_map : k => merge(v, {
      enable_dns_mapping = lookup(var.domain_map, k, null) != null
    })
  }
  output_data = {
    api_map = {
      for k_api, v_api in local.lx_map : k_api => merge(
        v_api,
        module.api.data[k_api],
        module.auth.data[k_api],
        module.integration.data[k_api],
        module.route.data[k_api],
        module.stage.data[k_api],
        {
          auth_map      = module.auth.data[k_api].auth_map # This is truly a passthrough and may be null here
          deployment_id = aws_apigatewayv2_deployment.this_deployment[k_api].id
          integration_map = {
            for k_int, v_int in v_api.integration_map : k_int => merge(
              v_int,
              module.integration.data[k_api].integration_map[k_int],
              module.route.data[k_api].integration_map[k_int],
              {
                route_map = module.route.data[k_api].integration_map[k_int].route_map # This is truly a passthrough and may be null here
              },
            )
          }
          stage_map = {
            for k_stage, v_stage in v_api.stage_map : k_stage => merge(
              v_stage,
              module.stage.data[k_api].stage_map[k_stage],
            )
          }
        }
      )
    }
    domain_map = module.domain.data
  }
  route_map = {
    for k_api, v_api in local.integration_map : k_api => merge(v_api, {
      auth_map = module.auth.data[k_api].auth_map
      integration_map = {
        for k_int, v_int in v_api.integration_map : k_int => merge(v_int, {
          integration_id = module.integration.data[k_api].integration_map[k_int].integration_id
        })
      }
    })
  }
  stage_map = {
    for k_api, v_api in local.route_map : k_api => merge(v_api, {
      deployment_id = aws_apigatewayv2_deployment.this_deployment[k_api].id
      domain_id     = v_api.enable_dns_mapping ? module.domain.data[k_api].domain_id : null
      integration_map = {
        for k_int, v_int in v_api.integration_map : k_int => merge(v_int, {
          route_map = module.route.data[k_api].integration_map[k_int].route_map
        })
      }
    })
  }
}
