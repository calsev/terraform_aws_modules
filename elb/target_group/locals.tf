module "name_map" {
  source                          = "../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

module "vpc_map" {
  source          = "../../vpc/id_map"
  vpc_data_map    = var.vpc_data_map
  vpc_key_default = var.vpc_key_default
  vpc_map         = local.l0_map
}

locals {
  l0_map = {
    for k, v in var.target_map : k => merge(v, {
      name_include_app_fields = false # name is limited to 32 characters
    })
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      draining_to_unused_delay_seconds            = v.draining_to_unused_delay_seconds == null ? var.target_draining_to_unused_delay_seconds_default : v.draining_to_unused_delay_seconds
      glb_failover_on_deregistration_or_unhealthy = v.glb_failover_on_deregistration_or_unhealthy == null ? var.target_glb_failover_on_deregistration_or_unhealthy_default : v.glb_failover_on_deregistration_or_unhealthy
      health_check_consecutive_fail_threshold     = v.health_check_consecutive_fail_threshold == null ? var.target_health_check_consecutive_fail_threshold_default : v.health_check_consecutive_fail_threshold
      health_check_consecutive_success_threshold  = v.health_check_consecutive_success_threshold == null ? var.target_health_check_consecutive_success_threshold_default : v.health_check_consecutive_success_threshold
      health_check_enabled                        = v.health_check_enabled == null ? var.target_health_check_enabled_default : v.health_check_enabled
      health_check_interval_seconds               = v.health_check_interval_seconds == null ? var.target_health_check_interval_seconds_default : v.health_check_interval_seconds
      health_check_no_response_timeout_seconds    = v.health_check_no_response_timeout_seconds == null ? var.target_health_check_no_response_timeout_seconds_default : v.health_check_no_response_timeout_seconds
      health_check_port                           = v.health_check_port == null ? var.target_health_check_port_default == null ? "traffic-port" : var.target_health_check_port_default : v.health_check_port
      lambda_multi_value_headers_enabled          = v.lambda_multi_value_headers_enabled == null ? var.target_lambda_multi_value_headers_enabled_default : v.lambda_multi_value_headers_enabled
      load_balancing_cross_zone_mode              = v.load_balancing_cross_zone_mode == null ? var.target_load_balancing_cross_zone_mode_default : v.load_balancing_cross_zone_mode
      sticky_cookie_duration_seconds              = v.sticky_cookie_duration_seconds == null ? var.target_sticky_cookie_duration_seconds_default : v.sticky_cookie_duration_seconds
      sticky_cookie_enabled                       = v.sticky_cookie_enabled == null ? var.target_sticky_cookie_enabled_default : v.sticky_cookie_enabled
      sticky_cookie_name                          = v.sticky_cookie_name == null ? var.target_sticky_cookie_name_default : v.sticky_cookie_name
      target_ip_use_v6                            = v.target_ip_use_v6 == null ? var.target_ip_use_v6_default : v.target_ip_use_v6
      target_protocol                             = v.target_protocol == null ? var.target_protocol_default : v.target_protocol
      target_type                                 = v.target_type == null ? var.target_type_default : v.target_type
      target_warm_up_seconds                      = v.target_warm_up_seconds == null ? var.target_warm_up_seconds_default : v.target_warm_up_seconds
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      glb_failover_on_deregistration_or_unhealthy_mode   = local.l1_map[k].glb_failover_on_deregistration_or_unhealthy ? "rebalance" : "no_rebalance"
      health_check_protocol                              = v.health_check_protocol == null ? var.target_health_check_protocol_default == null ? startswith(local.l1_map[k].target_protocol, "HTTP") ? "HTTP" : "TCP" : var.target_health_check_protocol_default : v.health_check_protocol
      is_glb                                             = contains(["GENEVE"], local.l1_map[k].target_protocol)
      is_nlb                                             = contains(["TCP", "TCP_UDP", "TLS", "UDP"], local.l1_map[k].target_protocol)
      nlb_terminate_connection_on_deregistration_timeout = local.l1_map[k].target_protocol == "UDP" ? true : v.nlb_terminate_connection_on_deregistration_timeout == null ? var.target_nlb_terminate_connection_on_deregistration_timeout_default : v.nlb_terminate_connection_on_deregistration_timeout
      nlb_terminate_connection_on_unhealthy              = local.l1_map[k].target_protocol == "UDP" ? false : v.nlb_terminate_connection_on_unhealthy == null ? var.target_nlb_terminate_connection_on_unhealthy_default : v.nlb_terminate_connection_on_unhealthy
      sticky_type                                        = v.sticky_type == null ? var.target_sticky_type_default == null ? startswith(local.l1_map[k].target_protocol, "HTTP") ? "lb_cookie" : "source_ip" : var.target_sticky_type_default : v.sticky_type
      sticky_supported                                   = local.l1_map[k].target_type != "lambda"
      target_port                                        = local.l1_map[k].target_type == "lambda" ? null : v.target_port == null ? var.target_port_default : v.target_port
      target_protocol_http_version                       = startswith(local.l1_map[k].target_protocol, "HTTP") ? v.target_protocol_http_version == null ? var.target_protocol_http_version_default : v.target_protocol_http_version : null
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      health_check_http_path                    = startswith(local.l2_map[k].health_check_protocol, "HTTP") ? v.health_check_http_path == null ? var.target_health_check_http_path_default : v.health_check_http_path : null
      health_check_success_code_list            = startswith(local.l2_map[k].health_check_protocol, "HTTP") ? v.health_check_success_code_list == null ? var.target_health_check_success_code_list_default : v.health_check_success_code_list : null
      load_balancing_algorithm_type             = local.l2_map[k].is_nlb ? null : v.load_balancing_algorithm_type == null ? var.target_load_balancing_algorithm_type_default : v.load_balancing_algorithm_type
      load_balancing_anomaly_mitigation_enabled = local.l2_map[k].is_nlb ? null : v.load_balancing_anomaly_mitigation_enabled == null ? var.target_load_balancing_anomaly_mitigation_enabled_default : v.load_balancing_anomaly_mitigation_enabled
      nlb_enable_proxy_protocol_v2              = local.l2_map[k].is_nlb ? v.nlb_enable_proxy_protocol_v2 == null ? var.target_nlb_enable_proxy_protocol_v2_default : v.nlb_enable_proxy_protocol_v2 : null
      nlb_preserve_client_ip                    = local.l2_map[k].is_nlb ? v.nlb_preserve_client_ip == null ? var.target_nlb_preserve_client_ip_default : v.nlb_preserve_client_ip : null
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        target_group_arn        = aws_lb_target_group.this_target[k].arn
        target_group_arn_suffix = aws_lb_target_group.this_target[k].arn_suffix
        target_group_name       = aws_lb_target_group.this_target[k].name
      }
    )
  }
}
