resource "aws_lb" "this_lb" {
  for_each = local.lx_map
  dynamic "access_logs" {
    for_each = each.value.access_log_bucket == null ? {} : { this = {} }
    content {
      bucket  = each.value.access_log_bucket
      enabled = each.value.access_log_enabled
      prefix  = null # Objects are already fully prefixed and this complicates S3 policy
    }
  }
  dynamic "connection_logs" {
    for_each = each.value.connection_log_bucket == null ? {} : { this = {} }
    content {
      bucket  = each.value.connection_log_bucket
      enabled = each.value.connection_log_enabled
      prefix  = null # Objects are already fully prefixed and this complicates S3 policy
    }
  }
  customer_owned_ipv4_pool                                     = null
  desync_mitigation_mode                                       = each.value.desync_mitigation_mode
  dns_record_client_routing_policy                             = each.value.dns_record_client_routing_policy
  drop_invalid_header_fields                                   = each.value.drop_invalid_header_fields
  enable_cross_zone_load_balancing                             = each.value.enable_cross_zone_load_balancing
  enable_deletion_protection                                   = each.value.enable_deletion_protection
  enable_http2                                                 = each.value.enable_http2
  enable_tls_version_and_cipher_suite_headers                  = each.value.enable_tls_version_and_cipher_suite_headers
  enable_xff_client_port                                       = each.value.enable_xff_client_port
  enable_waf_fail_open                                         = each.value.enable_waf_fail_open
  enforce_security_group_inbound_rules_on_private_link_traffic = each.value.enforce_security_group_inbound_rules_on_private_link_traffic == null ? null : each.value.enforce_security_group_inbound_rules_on_private_link_traffic ? "on" : "off"
  idle_timeout                                                 = each.value.idle_connection_timeout_seconds
  internal                                                     = each.value.is_internal
  ip_address_type                                              = each.value.enable_dualstack_networking ? "dualstack" : "ipv4"
  load_balancer_type                                           = each.value.load_balancer_type
  name                                                         = each.value.name_effective
  name_prefix                                                  = null
  preserve_host_header                                         = each.value.preserve_host_header
  security_groups                                              = each.value.vpc_security_group_id_list
  dynamic "subnet_mapping" {
    for_each = each.value.subnet_map
    content {
      allocation_id        = null # TODO?
      ipv6_address         = null
      private_ipv4_address = null
      subnet_id            = subnet_mapping.value.subnet_id
    }
  }
  subnets                    = null # Conflicts with subnet_mapping
  tags                       = each.value.tags
  xff_header_processing_mode = each.value.xff_header_processing_mode
}

module "elb_listener" {
  source                             = "../../elb/listener"
  dns_data                           = var.dns_data
  elb_data_map                       = local.elb_data_map_emulated
  listener_dns_from_zone_key_default = var.elb_dns_from_zone_key_default
  listener_map                       = local.create_listener_x_map
  std_map                            = var.std_map
}
