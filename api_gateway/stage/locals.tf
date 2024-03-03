locals {
  log_format_map = {
    for v in local.log_format_list : v => "$context.${v}"
  }
  mapping_map = {
    for k_api, v_api in local.stage_map : k_api => v_api if v_api.enable_dns_mapping
  }
  route_list = {
    for k_api, v_api in var.api_map : k_api => flatten([
      for k_int, v_int in v_api.integration_map : [
        for k_route, v_route in v_int.route_map : merge(v_route, {
          k_route = k_route # These have to be unique per API
        })
      ]
    ])
  }
  route_map = {
    for k_api, v_api in local.route_list : k_api => {
      for v_route in v_api : v_route.k_route => {
        for k, v in v_route : k => v if !contains(["k_route"], k)
      }
    }
  }
  stage_list = flatten([
    for k_api, v_api in var.api_map : [
      for k_stage, v_stage in v_api.stage_map : merge(
        { for k, v in v_api : k => v if !contains(["integration_map", "stage_map"], k) },
        v_stage,
        {
          detailed_metrics_enabled = v_stage.detailed_metrics_enabled == null ? var.stage_detailed_metrics_enabled_default : v_stage.detailed_metrics_enabled
          enable_default_route     = v_stage.enable_default_route == null ? var.stage_enable_default_route_default : v_stage.enable_default_route
          k_api                    = k_api
          k_stage                  = k_stage
          name                     = replace("${k_api}_${k_stage}", var.std_map.name_replace_regex, "-")
          route_map                = local.route_map[k_api]
          stage_path               = v_stage.stage_path == null ? k_stage == "$default" ? "" : k_stage : v_stage.stage_path
          tags = merge(
            var.std_map.tags,
            {
              Name = "${var.std_map.resource_name_prefix}${replace("${k_api}_${k_stage}", var.std_map.name_replace_regex, "-")}${var.std_map.resource_name_suffix}"
            }
          )
          throttling_burst_limit = v_stage.throttling_burst_limit == null ? var.stage_throttling_burst_limit_default : v_stage.throttling_burst_limit
          throttling_rate_limit  = v_stage.throttling_rate_limit == null ? var.stage_throttling_rate_limit_default : v_stage.throttling_rate_limit
        },
      )
    ]
  ])
  stage_map = {
    for stage in local.stage_list : "${stage.k_api}_${stage.k_stage}" => stage
  }
  output_data = {
    for k_api, v_api in var.api_map : k_api => merge(v_api, {
      stage_map = {
        for k_stage, v_stage in v_api.stage_map : k_stage => merge(
          v_stage,
          {
            for k, v in local.stage_map["${k_api}_${k_stage}"] : k => v if !contains(["k_api", "k_stage"], k)
          },
          {
            stage_id = aws_apigatewayv2_stage.this_stage["${k_api}_${k_stage}"].id
            log      = module.stage_log.data["${k_api}_${k_stage}"]
          },
        )
      }
    })
  }
}
