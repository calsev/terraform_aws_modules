module "name_map" {
  source             = "../name_map"
  name_infix_default = var.table_name_infix_default
  name_map           = var.table_map
  std_map            = var.std_map
}

locals {
  output_data = {
    for k, v_table in local.table_map : k => merge(
      v_table,
      {
        table_arn = aws_dynamodb_table.this_table[k].arn
      },
    )
  }
  table_map = {
    for k, v in var.table_map : k => merge(v, module.name_map.data[k], {
      attribute_map                  = v.attribute_map == null ? var.table_attribute_map_default : v.attribute_map
      hash_key                       = v.hash_key == null ? var.table_hash_key_default : v.hash_key
      point_in_time_recovery_enabled = v.point_in_time_recovery_enabled == null ? var.table_point_in_time_recovery_enabled_default : v.point_in_time_recovery_enabled
      server_side_encryption_enabled = v.server_side_encryption_enabled == null ? var.table_server_side_encryption_enabled_default : v.server_side_encryption_enabled
    })
  }
}
