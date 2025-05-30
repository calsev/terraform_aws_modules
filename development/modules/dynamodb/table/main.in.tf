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
    for_each = each.value.has_gsi ? { this = {} } : {}
    content {
      hash_key           = each.value.gsi_hash_key
      name               = each.value.gsi_name
      non_key_attributes = each.value.gsi_non_key_attribute_list
      projection_type    = each.value.gsi_projection_type
      range_key          = each.value.gsi_range_key
      read_capacity      = each.value.gsi_read_capacity
      write_capacity     = each.value.gsi_write_capacity
    }
  }
  hash_key = each.value.hash_key
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

{{ iam.policy_identity_ar_type(policy_name="policy", suffix="dynamodb/table") }}
