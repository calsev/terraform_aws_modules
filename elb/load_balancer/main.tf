resource "aws_lb" "this_lb" {
  for_each = local.lx_map
  dynamic "access_logs" {
    for_each = each.value.log_access_bucket == null ? {} : { this = {} }
    content {
      bucket  = each.value.log_access_bucket
      enabled = each.value.log_access_enabled
      prefix  = each.value.log_prefix_access
    }
  }
  dynamic "connection_logs" {
    for_each = each.value.log_connection_bucket == null ? {} : { this = {} }
    content {
      bucket  = each.value.log_connection_bucket
      enabled = each.value.log_connection_enabled
      prefix  = each.value.log_prefix_connection
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
  ip_address_type                                              = each.value.ip_address_type
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

resource "aws_wafv2_web_acl_association" "waf" {
  for_each     = local.associate_waf_map
  resource_arn = each.value.elb_id
  web_acl_arn  = each.value.waf_arn
}

module "elb_listener" {
  source                             = "../../elb/listener"
  dns_data                           = var.dns_data
  elb_data_map                       = local.elb_data_map_emulated
  listener_dns_from_zone_key_default = var.elb_dns_from_zone_key_default
  listener_map                       = local.create_listener_x_map
  std_map                            = var.std_map
}

module "log_access_db" {
  source              = "../../athena/database"
  db_map              = local.create_db_access_map
  name_append_default = "elb_access"
  std_map             = var.std_map
}

module "log_access_table_query" {
  source              = "../../athena/named_query"
  athena_database_map = module.log_access_db.data
  name_append_default = "elb_access"
  query_map           = local.create_db_access_map
  std_map             = var.std_map
}

module "log_connection_db" {
  source              = "../../athena/database"
  db_map              = local.create_db_connection_map
  name_append_default = "elb_connection"
  std_map             = var.std_map
}

module "log_connection_table_query" {
  source              = "../../athena/named_query"
  athena_database_map = module.log_connection_db.data
  name_append_default = "elb_connection"
  query_map           = local.create_db_connection_map
  std_map             = var.std_map
}
