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

locals {
  create_policy_map = {
    for k, v in local.lx_map : k => merge(v, {
      name_map_table = {
        (v.name_effective) = {}
      }
    })
  }
  l0_map = {
    for k, v in var.table_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      attribute_map                  = v.attribute_map == null ? var.table_attribute_map_default : v.attribute_map
      billing_mode                   = v.billing_mode == null ? var.table_billing_mode_default : v.billing_mode
      create_policy                  = v.create_policy == null ? var.table_create_policy_default : v.create_policy
      deletion_protection_enabled    = v.deletion_protection_enabled == null ? var.table_deletion_protection_enabled_default : v.deletion_protection_enabled
      gsi_hash_key                   = v.gsi_hash_key == null ? var.table_gsi_hash_key_default : v.gsi_hash_key
      gsi_name                       = v.gsi_name == null ? var.table_gsi_name_default : v.gsi_name
      gsi_non_key_attribute_list     = v.gsi_non_key_attribute_list == null ? var.table_gsi_non_key_attribute_list_default : v.gsi_non_key_attribute_list
      gsi_projection_type            = v.gsi_projection_type == null ? var.table_gsi_projection_type_default : v.gsi_projection_type
      gsi_range_key                  = v.gsi_range_key == null ? var.table_gsi_range_key_default : v.gsi_range_key
      gsi_read_capacity              = v.gsi_read_capacity == null ? var.table_gsi_read_capacity_default : v.gsi_read_capacity
      gsi_write_capacity             = v.gsi_write_capacity == null ? var.table_gsi_write_capacity_default : v.gsi_write_capacity
      hash_key                       = v.hash_key == null ? var.table_hash_key_default : v.hash_key
      lsi_name                       = v.lsi_name == null ? var.table_lsi_name_default : v.lsi_name
      lsi_non_key_attribute_list     = v.lsi_non_key_attribute_list == null ? var.table_lsi_non_key_attribute_list_default : v.lsi_non_key_attribute_list
      lsi_projection_type            = v.lsi_projection_type == null ? var.table_lsi_projection_type_default : v.lsi_projection_type
      lsi_range_key                  = v.lsi_range_key == null ? var.table_lsi_range_key_default : v.lsi_range_key
      point_in_time_recovery_enabled = v.point_in_time_recovery_enabled == null ? var.table_point_in_time_recovery_enabled_default : v.point_in_time_recovery_enabled
      range_key                      = v.range_key == null ? var.table_range_key_default : v.range_key
      read_capacity                  = v.read_capacity == null ? var.table_read_capacity_default : v.read_capacity
      server_side_encryption_enabled = v.server_side_encryption_enabled == null ? var.table_server_side_encryption_enabled_default : v.server_side_encryption_enabled
      stream_enabled                 = v.stream_enabled == null ? var.table_stream_enabled_default : v.stream_enabled
      stream_view_type               = v.stream_view_type == null ? var.table_stream_view_type_default : v.stream_view_type
      ttl_attribute_name             = v.ttl_attribute_name == null ? var.table_ttl_attribute_name_default : v.ttl_attribute_name
      write_capacity                 = v.write_capacity == null ? var.table_write_capacity_default : v.write_capacity
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      has_gsi     = local.l1_map[k].gsi_hash_key != null && local.l1_map[k].gsi_name != null
      has_lsi     = local.l1_map[k].lsi_name != null && local.l1_map[k].lsi_range_key != null
      policy_name = "${k}_dynamodb"
      ttl_enabled = local.l1_map[k].ttl_attribute_name != null
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      v,
      {
        policy    = v.create_policy ? module.policy.data[k] : null
        table_arn = aws_dynamodb_table.this_table[k].arn
      },
    )
  }
}
