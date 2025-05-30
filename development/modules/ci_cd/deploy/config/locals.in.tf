{{ name.map() }}

locals {
  l0_map = {
    for k, v in var.deployment_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      compute_platform                    = v.compute_platform == null ? var.deployment_compute_platform_default : v.compute_platform
      host_healthy_metric                 = v.host_healthy_metric == null ? var.deployment_host_healthy_metric_default : v.host_healthy_metric
      host_healthy_min_value              = v.host_healthy_min_value == null ? var.deployment_host_healthy_min_value_default : v.host_healthy_min_value
      traffic_routing_interval_minutes    = v.traffic_routing_interval_minutes == null ? var.deployment_traffic_routing_interval_minutes_default : v.traffic_routing_interval_minutes
      traffic_routing_interval_percentage = v.traffic_routing_interval_percentage == null ? var.deployment_traffic_routing_interval_percentage_default : v.traffic_routing_interval_percentage
      traffic_routing_type                = v.traffic_routing_type == null ? var.deployment_traffic_routing_type_default : v.traffic_routing_type
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      host_healthy_metric_effective    = local.l1_map[k].compute_platform == "Server" ? local.l1_map[k].host_healthy_metric : null
      host_healthy_min_value_effective = local.l1_map[k].compute_platform == "Server" ? local.l1_map[k].host_healthy_min_value : null
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
        config_arn = aws_codedeploy_deployment_config.this_config[k].arn
        config_id  = aws_codedeploy_deployment_config.this_config[k].id
      }
    )
  }
}
