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
  associate_waf_map = {
    for k, v in local.lx_map : k => merge(v, {
      elb_id = aws_lb.this_lb[k].id
    }) if v.waf_arn != null
  }
  create_db_access_map = {
    for k, v in local.lx_map : k => merge(v, {
      bucket_name  = v.log_db_bucket
      database_key = k
      # https://docs.aws.amazon.com/athena/latest/ug/application-load-balancer-logs.html
      query = <<-EOT
      CREATE EXTERNAL TABLE IF NOT EXISTS elb_${replace(v.name_effective, "-", "_")}_access_logs (
        type string,
        time string,
        elb string,
        client_ip string,
        client_port int,
        target_ip string,
        target_port int,
        request_processing_time double,
        target_processing_time double,
        response_processing_time double,
        elb_status_code int,
        target_status_code string,
        received_bytes bigint,
        sent_bytes bigint,
        request_verb string,
        request_url string,
        request_proto string,
        user_agent string,
        ssl_cipher string,
        ssl_protocol string,
        target_group_arn string,
        trace_id string,
        domain_name string,
        chosen_cert_arn string,
        matched_rule_priority string,
        request_creation_time string,
        actions_executed string,
        redirect_url string,
        lambda_error_reason string,
        target_port_list string,
        target_status_code_list string,
        classification string,
        classification_reason string,
        traceability_id string
      )
      PARTITIONED BY
      (
        day STRING
      )
      ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
      WITH SERDEPROPERTIES (
        'serialization.format' = '1',
        'input.regex' = '([^ ]*) ([^ ]*) ([^ ]*) ([^ ]*):([0-9]*) ([^ ]*)[:-]([0-9]*) ([-.0-9]*) ([-.0-9]*) ([-.0-9]*) (|[-0-9]*) (-|[-0-9]*) ([-0-9]*) ([-0-9]*) \"([^ ]*) (.*) (- |[^ ]*)\" \"([^\"]*)\" ([A-Z0-9-_]+) ([A-Za-z0-9.-]*) ([^ ]*) \"([^\"]*)\" \"([^\"]*)\" \"([^\"]*)\" ([-.0-9]*) ([^ ]*) \"([^\"]*)\" \"([^\"]*)\" \"([^ ]*)\" \"([^\s]+?)\" \"([^\s]+)\" \"([^ ]*)\" \"([^ ]*)\" ?([^ ]*)?( .*)?'
      )
      LOCATION 's3://${v.log_db_bucket}/${v.log_prefix_access}/AWSLogs/${var.std_map.aws_account_id}/elasticloadbalancing/${var.std_map.aws_region_name}/'
      TBLPROPERTIES
      (
        "projection.enabled" = "true",
        "projection.day.type" = "date",
        "projection.day.range" = "2022/01/01,NOW",
        "projection.day.format" = "yyyy/MM/dd",
        "projection.day.interval" = "1",
        "projection.day.interval.unit" = "DAYS",
        "storage.location.template" = "s3://${v.log_db_bucket}/${v.log_prefix_access}/AWSLogs/${var.std_map.aws_account_id}/elasticloadbalancing/${var.std_map.aws_region_name}/$${day}"
      )
      EOT
    }) if v.log_db_enabled
  }
  create_db_connection_map = {
    for k, v in local.lx_map : k => merge(v, {
      bucket_name  = v.log_db_bucket
      database_key = k
      query        = <<-EOT
      CREATE EXTERNAL TABLE IF NOT EXISTS elb_${replace(v.name_effective, "-", "_")}_connection_logs (
        time string,
        client_ip string,
        client_port int,
        listener_port int,
        tls_protocol string,
        tls_cipher string,
        tls_handshake_latency double,
        leaf_client_cert_subject string,
        leaf_client_cert_validity string,
        leaf_client_cert_serial_number string,
        tls_verify_status string,
        traceability_id string
      )
      PARTITIONED BY
      (
        day STRING
      )
      ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
      WITH SERDEPROPERTIES (
        'serialization.format' = '1',
        'input.regex' = '([^ ]*) ([^ ]*) ([0-9]*) ([0-9]*) ([A-Za-z0-9.-]*) ([^ ]*) ([-.0-9]*) \"([^\"]*)\" ([^ ]*) ([^ ]*) ([^ ]*) ?([^ ]*)?( .*)?'
      )
      LOCATION 's3://${v.log_db_bucket}/${v.log_prefix_connection}/AWSLogs/${var.std_map.aws_account_id}/elasticloadbalancing/${var.std_map.aws_region_name}/'
      TBLPROPERTIES
      (
        "projection.enabled" = "true",
        "projection.day.type" = "date",
        "projection.day.range" = "2023/01/01,NOW",
        "projection.day.format" = "yyyy/MM/dd",
        "projection.day.interval" = "1",
        "projection.day.interval.unit" = "DAYS",
        "storage.location.template" = "s3://${v.log_db_bucket}/${v.log_prefix_connection}/AWSLogs/${var.std_map.aws_account_id}/elasticloadbalancing/${var.std_map.aws_region_name}/$${day}"
      )
      EOT
    }) if v.log_db_enabled
  }
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
      log_access_bucket                           = v.log_access_bucket == null ? var.elb_log_access_bucket_default : v.log_access_bucket
      log_connection_enabled                      = v.log_connection_enabled == null ? var.elb_log_connection_enabled_default : v.log_connection_enabled
      log_db_enabled                              = v.log_db_enabled == null ? var.elb_log_db_enabled_default : v.log_db_enabled
      preserve_host_header                        = v.preserve_host_header == null ? var.elb_preserve_host_header_default : v.preserve_host_header
      xff_header_processing_mode                  = v.xff_header_processing_mode == null ? var.elb_xff_header_processing_mode_default : v.xff_header_processing_mode
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      dns_record_client_routing_policy                             = local.l1_map[k].load_balancer_type == "network" ? v.dns_record_client_routing_policy == null ? var.elb_dns_record_client_routing_policy_default : v.dns_record_client_routing_policy : null
      enforce_security_group_inbound_rules_on_private_link_traffic = local.l1_map[k].load_balancer_type == "network" ? v.enforce_security_group_inbound_rules_on_private_link_traffic == null ? var.elb_enforce_security_group_inbound_rules_on_private_link_traffic_default : v.enforce_security_group_inbound_rules_on_private_link_traffic : null
      ip_address_type                                              = v.ip_address_type == null ? var.elb_ip_address_type_default == null ? local.l1_map[k].load_balancer_type == "application" ? "dualstack" : "ipv4" : var.elb_ip_address_type_default : v.ip_address_type
      log_access_enabled                                           = v.log_access_enabled == null ? var.elb_log_access_enabled_default == null ? local.l1_map[k].load_balancer_type == "application" : var.elb_log_access_enabled_default : v.log_access_enabled
      log_connection_bucket                                        = v.log_connection_bucket == null ? var.elb_log_connection_bucket_default == null ? local.l1_map[k].log_access_bucket : var.elb_log_connection_bucket_default : v.log_connection_bucket
      log_db_bucket                                                = v.log_db_bucket == null ? var.elb_log_db_bucket_default == null ? local.l1_map[k].log_access_bucket : var.elb_log_db_bucket_default : v.log_db_bucket
      log_prefix_access                                            = "elb-${local.l1_map[k].name_effective}-access"
      log_prefix_connection                                        = "elb-${local.l1_map[k].name_effective}-connection"
      port_to_protocol_to_listener_map                             = v.port_to_protocol_to_listener_map == null ? var.elb_type_to_port_to_protocol_to_listener_map_default[local.l1_map[k].load_balancer_type] : v.port_to_protocol_to_listener_map
      subnet_map = {
        for k_az, subnet_id in local.l1_map[k].vpc_subnet_id_map : k_az => {
          subnet_id = subnet_id
        }
      }
      waf_key = local.l1_map[k].load_balancer_type == "application" ? v.waf_key == null ? var.elb_waf_key_default : v.waf_key : null
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      waf_arn = local.l2_map[k].waf_key == null ? null : var.waf_data_map[local.l2_map[k].waf_key].waf_arn
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
      local.elb_data_map_emulated[k],
      {
        elb_arn_suffix             = aws_lb.this_lb[k].arn_suffix
        elb_id                     = aws_lb.this_lb[k].id
        log_access_db              = v.log_db_enabled ? module.log_access_db.data[k] : null
        log_access_table_query     = v.log_db_enabled ? module.log_access_table_query.data[k] : null
        log_connection_db          = v.log_db_enabled ? module.log_connection_db.data[k] : null
        log_connection_table_query = v.log_db_enabled ? module.log_connection_table_query.data[k] : null
        port_to_protocol_to_listener_map = {
          for k_port, v_port in v.port_to_protocol_to_listener_map : k_port => {
            for k_proto, v_proto in v_port : k_proto => merge(v_proto, module.elb_listener.data["${k}_${k_port}_${k_proto}"])
          }
        }
      }
    )
  }
}
