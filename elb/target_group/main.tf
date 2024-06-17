resource "aws_lb_target_group" "this_target" {
  for_each               = local.lx_map
  connection_termination = each.value.nlb_terminate_connection_on_deregistration_timeout
  deregistration_delay   = each.value.draining_to_unused_delay_seconds
  dynamic "health_check" {
    for_each = { this = {} }
    content {
      enabled             = each.value.health_check_enabled
      healthy_threshold   = each.value.health_check_consecutive_success_threshold
      interval            = each.value.health_check_interval_seconds
      matcher             = each.value.health_check_success_code_list == null ? null : join(",", each.value.health_check_success_code_list)
      path                = each.value.health_check_http_path
      port                = each.value.health_check_port
      protocol            = each.value.health_check_protocol
      timeout             = each.value.health_check_no_response_timeout_seconds
      unhealthy_threshold = each.value.health_check_consecutive_fail_threshold
    }
  }
  ip_address_type                    = each.value.target_ip_use_v6 ? "ipv6" : "ipv4"
  lambda_multi_value_headers_enabled = each.value.lambda_multi_value_headers_enabled
  lifecycle {
    create_before_destroy = true
  }
  load_balancing_algorithm_type     = each.value.load_balancing_algorithm_type
  load_balancing_anomaly_mitigation = each.value.load_balancing_anomaly_mitigation_enabled == null ? null : each.value.load_balancing_anomaly_mitigation_enabled ? "on" : "off"
  load_balancing_cross_zone_enabled = each.value.load_balancing_cross_zone_mode
  # name_prefix # Conflicts with name, and max 6 chars
  name               = each.value.name_effective
  port               = each.value.target_port
  preserve_client_ip = each.value.nlb_preserve_client_ip
  protocol           = each.value.target_protocol
  protocol_version   = each.value.target_protocol_http_version
  proxy_protocol_v2  = each.value.nlb_enable_proxy_protocol_v2
  slow_start         = each.value.target_warm_up_seconds
  dynamic "stickiness" {
    for_each = { this = {} }
    content {
      cookie_duration = each.value.sticky_cookie_duration_seconds
      cookie_name     = each.value.sticky_cookie_name
      enabled         = each.value.sticky_cookie_enabled
      type            = each.value.sticky_type
    }
  }
  tags = each.value.tags
  dynamic "target_failover" {
    for_each = each.value.is_glb ? { this = {} } : {}
    content {
      on_deregistration = each.value.glb_failover_on_deregistration_or_unhealthy_mode # These must match
      on_unhealthy      = each.value.glb_failover_on_deregistration_or_unhealthy_mode # These must match
    }
  }
  dynamic "target_health_state" {
    for_each = each.value.is_nlb ? { this = {} } : {}
    content {
      enable_unhealthy_connection_termination = each.value.nlb_terminate_connection_on_unhealthy
    }
  }
  target_type = each.value.target_type
  vpc_id      = each.value.vpc_id
}
