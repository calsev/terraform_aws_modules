resource "aws_codedeploy_deployment_config" "this_config" {
  for_each               = local.lx_map
  deployment_config_name = each.value.name_effective
  compute_platform       = each.value.compute_platform
  dynamic "minimum_healthy_hosts" {
    for_each = each.value.compute_platform == "Server" ? { this = {} } : {}
    content {
      type  = each.value.host_healthy_metric_effective
      value = each.value.host_healthy_min_value_effective
    }
  }
  traffic_routing_config {
    type = each.value.traffic_routing_type
    dynamic "time_based_canary" {
      for_each = each.value.traffic_routing_type == "TimeBasedCanary" ? { this = {} } : {}
      content {
        interval   = each.value.traffic_routing_interval_minutes
        percentage = each.value.traffic_routing_interval_percentage
      }
    }
    dynamic "time_based_linear" {
      for_each = each.value.traffic_routing_type == "TimeBasedLinear" ? { this = {} } : {}
      content {
        interval   = each.value.traffic_routing_interval_minutes
        percentage = each.value.traffic_routing_interval_percentage
      }
    }
  }
}
