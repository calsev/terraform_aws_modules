locals {
  l1_map = {
    for k_api, v_api in var.api_map : k_api => merge(v_api, {
      integration_map = {
        for k_int, v_int in v_api.integration_map : k_int => merge(v_int, {
          integration_id = v_int.integration_id == null ? var.route_integration_id_default : v_int.integration_id
          route_map = v_int.route_map != null ? v_int.route_map : {
            "${v_api.integration_route_method_default} /${k_int}" = {
              auth_key             = null
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
  l2_list = flatten([
    for k_api, v_api in local.l1_map : [
      for k_int, v_int in v_api.integration_map : [
        for k_route, v_route in v_int.route_map : merge(
          { for k, v in v_api : k => v if !contains(["auth_map", "integration_map"], k) },
          { for k, v in v_int : k => v if !contains(["route_map"], k) },
          v_route,
          {
            auth_key             = v_route.auth_key == null ? v_api.integration_route_auth_key_default : v_route.auth_key
            authorization_scopes = v_route.authorization_scopes == null ? var.route_authorization_scopes_default : v_route.authorization_scopes
            k_api                = k_api
            k_int                = k_int
            k_route              = k_route
            integration_id       = v_int.integration_id == null ? null : "integrations/${v_int.integration_id}"
          },
        )
      ]
    ]
  ])
  l3_list = [
    for v_route in local.l2_list : merge(v_route, {
      authorization_type = v_route.auth_key == null ? v_route.authorization_type == null ? var.route_authorization_type_default : v_route.authorization_type : local.l1_map[v_route.k_api].auth_map[v_route.auth_key].route_authorization_type
      authorizer_id      = v_route.auth_key == null ? v_route.authorizer_id == null ? var.route_authorizer_id_default : v_route.authorizer_id : local.l1_map[v_route.k_api].auth_map[v_route.auth_key].authorizer_id
    })
  ]
  lx_map = {
    for route in local.l3_list : "${route.k_api}_${route.k_int}_${route.k_route}" => route
  }
  output_data = {
    for k_api, v_api in local.l1_map : k_api => merge(v_api, {
      integration_map = {
        for k_int, v_int in v_api.integration_map : k_int => merge(v_int, {
          route_map = {
            for k_route, v_route in v_int.route_map : k_route => merge(
              v_route,
              {
                for k, v in local.lx_map["${k_api}_${k_int}_${k_route}"] : k => v if !contains(["k_api", "k_int", "k_route"], k)
              },
              {
                route_id = aws_apigatewayv2_route.this_route["${k_api}_${k_int}_${k_route}"].id
              },
            )
          }
        })
      }
    })
  }
}
