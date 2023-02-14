resource "aws_dynamodb_table" "this_table" {
  for_each = local.table_map
  dynamic "attribute" {
    for_each = each.value.attribute_map
    content {
      name = attribute.key
      type = attribute.value
    }
  }
  billing_mode = "PAY_PER_REQUEST" # TODO
  # global_secondary_index # TODO
  hash_key = each.value.hash_key
  # local_secondary_index # TODO
  name = each.value.table_name
  point_in_time_recovery {
    enabled = each.value.point_in_time_recovery_enabled
  }
  range_key     = null # TODO
  read_capacity = null # TODO
  # replica # TODO
  server_side_encryption {
    enabled     = each.value.server_side_encryption_enabled
    kms_key_arn = null # TODO
  }
  stream_enabled   = false # TODO
  stream_view_type = null  # TODO
  table_class      = "STANDARD"
  tags             = each.value.tags
  # ttl # TODO
  write_capacity = null # TODO
}
