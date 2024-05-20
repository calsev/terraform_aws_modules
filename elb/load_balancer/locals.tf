module "name_map" {
  source                          = "../../name_map"
  name_include_app_fields_default = var.elb_name_include_app_fields_default
  name_infix_default              = var.elb_name_infix_default
  name_map                        = local.l0_map
  std_map                         = var.std_map
}

module "vpc_map" {
  source                              = "../../vpc/id_map"
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_data_map                        = var.vpc_data_map
  vpc_key_default                     = var.vpc_key_default
  vpc_map                             = local.l0_map
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
  vpc_segment_key_default             = var.vpc_segment_key_default
}

locals {
  create_listener_1_list = flatten([
    for k, v in local.lx_map : [
      for k_port, v_port in v.port_to_protocol_to_listener_map : [
        for k_proto, v_proto in v_port : merge(v, v_proto, {
          action_map = {
            for k_act, v_act in v_proto.action_map : k_act => merge(v_act, {
              acm_certificate_key = v.acm_certificate_key
            })
          }
          k_all           = "${k}_${k_port}_${k_proto}"
          elb_key         = k
          listen_port     = k_port
          listen_protocol = k_proto
        })
      ]
    ]
  ])
  create_listener_x_map = {
    for v in local.create_listener_1_list : v.k_all => v
  }
  elb_data_map_emulated = {
    for k, v in local.lx_map : k => merge(v, {
      elb_arn                          = aws_lb.this_lb[k].arn
      elb_dns_name                     = aws_lb.this_lb[k].dns_name
      elb_dns_zone_id                  = aws_lb.this_lb[k].zone_id
      port_to_protocol_to_listener_map = {}
    })
  }
  l0_map = {
    for k, v in var.elb_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      access_log_bucket                           = v.access_log_bucket == null ? var.elb_access_log_bucket_default : v.access_log_bucket
      connection_log_enabled                      = v.connection_log_enabled == null ? var.elb_connection_log_enabled_default : v.connection_log_enabled
      desync_mitigation_mode                      = v.desync_mitigation_mode == null ? var.elb_desync_mitigation_mode_default : v.desync_mitigation_mode
      drop_invalid_header_fields                  = v.drop_invalid_header_fields == null ? var.elb_drop_invalid_header_fields_default : v.drop_invalid_header_fields
      enable_cross_zone_load_balancing            = v.enable_cross_zone_load_balancing == null ? var.elb_enable_cross_zone_load_balancing_default : v.enable_cross_zone_load_balancing
      enable_deletion_protection                  = v.enable_deletion_protection == null ? var.elb_enable_deletion_protection_default : v.enable_deletion_protection
      enable_http2                                = v.enable_http2 == null ? var.elb_enable_http2_default : v.enable_http2
      enable_tls_version_and_cipher_suite_headers = v.enable_tls_version_and_cipher_suite_headers == null ? var.elb_enable_tls_version_and_cipher_suite_headers_default : v.enable_tls_version_and_cipher_suite_headers
      enable_waf_fail_open                        = v.enable_waf_fail_open == null ? var.elb_enable_waf_fail_open_default : v.enable_waf_fail_open
      enable_xff_client_port                      = v.enable_xff_client_port == null ? var.elb_enable_xff_client_port_default : v.enable_xff_client_port
      idle_connection_timeout_seconds             = v.idle_connection_timeout_seconds == null ? var.elb_idle_connection_timeout_seconds_default : v.idle_connection_timeout_seconds
      is_internal                                 = v.is_internal == null ? var.elb_is_internal_default : v.is_internal
      load_balancer_type                          = v.load_balancer_type == null ? var.elb_load_balancer_type_default : v.load_balancer_type
      preserve_host_header                        = v.preserve_host_header == null ? var.elb_preserve_host_header_default : v.preserve_host_header
      xff_header_processing_mode                  = v.xff_header_processing_mode == null ? var.elb_xff_header_processing_mode_default : v.xff_header_processing_mode
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      access_log_enabled                                           = v.access_log_enabled == null ? var.elb_access_log_enabled_default == null ? local.l1_map[k].load_balancer_type == "application" : var.elb_access_log_enabled_default : v.access_log_enabled
      connection_log_bucket                                        = v.connection_log_bucket == null ? var.elb_connection_log_bucket_default == null ? local.l1_map[k].access_log_bucket : var.elb_connection_log_bucket_default : v.connection_log_bucket
      dns_record_client_routing_policy                             = local.l1_map[k].load_balancer_type == "network" ? v.dns_record_client_routing_policy == null ? var.elb_dns_record_client_routing_policy_default : v.dns_record_client_routing_policy : null
      enable_dualstack_networking                                  = v.enable_dualstack_networking == null ? var.elb_enable_dualstack_networking_default == null ? local.l1_map[k].load_balancer_type == "application" : var.elb_enable_dualstack_networking_default : v.enable_dualstack_networking
      enforce_security_group_inbound_rules_on_private_link_traffic = local.l1_map[k].load_balancer_type == "network" ? v.enforce_security_group_inbound_rules_on_private_link_traffic == null ? var.elb_enforce_security_group_inbound_rules_on_private_link_traffic_default : v.enforce_security_group_inbound_rules_on_private_link_traffic : null
      port_to_protocol_to_listener_map                             = v.port_to_protocol_to_listener_map == null ? var.elb_type_to_port_to_protocol_to_listener_map_default[local.l1_map[k].load_balancer_type] : v.port_to_protocol_to_listener_map
      subnet_map = {
        for k_az, subnet_id in local.l1_map[k].vpc_subnet_id_map : k_az => {
          subnet_id = subnet_id
        }
      }
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
      local.elb_data_map_emulated[k],
      {
        elb_arn_suffix = aws_lb.this_lb[k].arn_suffix
        port_to_protocol_to_listener_map = {
          for k_port, v_port in v.port_to_protocol_to_listener_map : k_port => {
            for k_proto, v_proto in v_port : k_proto => merge(v_proto, module.elb_listener.data["${k}_${k_port}_${k_proto}"])
          }
        }
      }
    )
  }
}
