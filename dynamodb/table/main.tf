resource "aws_dynamodb_table" "this_table" {
  for_each = local.lx_map
  dynamic "attribute" {
    for_each = each.value.attribute_map
    content {
      name = attribute.key
      type = attribute.value
    }
  }
  billing_mode                = each.value.billing_mode
  deletion_protection_enabled = each.value.deletion_protection_enabled
  dynamic "global_secondary_index" {
    for_each = each.value.gsi_map
    content {
      hash_key           = global_secondary_index.value.hash_key
      name               = global_secondary_index.key
      non_key_attributes = global_secondary_index.value.non_key_attribute_list
      projection_type    = global_secondary_index.value.projection_type
      range_key          = global_secondary_index.value.range_key
      read_capacity      = global_secondary_index.value.read_capacity
      write_capacity     = global_secondary_index.value.write_capacity
    }
  }
  hash_key = each.value.hash_key
  lifecycle {
    ignore_changes = [
      # Capacity requires frequent fiddling, and there is auto scaling
      read_capacity,
      write_capacity,
    ]
  }
  dynamic "local_secondary_index" {
    for_each = each.value.has_lsi ? { this = {} } : {}
    content {
      name               = each.value.lsi_name
      non_key_attributes = each.value.lsi_non_key_attribute_list
      projection_type    = each.value.lsi_projection_type
      range_key          = each.value.lsi_range_key
    }
  }
  name = each.value.name_effective
  point_in_time_recovery {
    enabled = each.value.point_in_time_recovery_enabled
  }
  range_key     = each.value.range_key
  read_capacity = each.value.read_capacity
  # replica # TODO
  restore_date_time      = null # TODO
  restore_source_name    = null # TODO
  restore_to_latest_time = null # TODO
  server_side_encryption {
    enabled     = each.value.server_side_encryption_enabled
    kms_key_arn = null # TODO
  }
  stream_enabled   = each.value.stream_enabled
  stream_view_type = each.value.stream_view_type
  table_class      = "STANDARD"
  tags             = each.value.tags
  dynamic "ttl" {
    for_each = each.value.ttl_enabled ? { this = {} } : {}
    content {
      enabled        = each.value.ttl_enabled
      attribute_name = each.value.ttl_attribute_name
    }
  }
  write_capacity = each.value.write_capacity
}

module "policy" {
  source                          = "../../iam/policy/identity/dynamodb/table"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  policy_access_list_default      = var.policy_access_list_default
  policy_create_default           = var.policy_create_default
  policy_map                      = local.create_policy_map
  policy_name_append_default      = var.policy_name_append_default
  policy_name_prefix_default      = var.policy_name_prefix_default
  std_map                         = var.std_map
}

module "alarm" {
  source               = "../../cw/metric_alarm"
  alarm_map            = local.create_alarm_x_map
  name_prepend_default = "table"
  std_map              = var.std_map
}
