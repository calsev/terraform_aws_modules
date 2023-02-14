locals {
  name_infix_map = {
    for k_table, v_table in var.table_map : k_table => v_table.name_infix == null ? var.table_name_infix_default : v_table.name_infix
  }
  output_data = {
    for k_table, v_table in local.table_map : k_table => merge(
      v_table,
      {
        table_arn = aws_dynamodb_table.this_table[k_table].arn
      },
    )
  }
  table_map = {
    for k_table, v in var.table_map : k_table => merge(v, {
      attribute_map                  = v.attribute_map == null ? var.table_attribute_map_default : v.attribute_map
      hash_key                       = v.hash_key == null ? var.table_hash_key_default : v.hash_key
      name_infix                     = local.name_infix_map[k_table]
      point_in_time_recovery_enabled = v.point_in_time_recovery_enabled == null ? var.table_point_in_time_recovery_enabled_default : v.point_in_time_recovery_enabled
      resource_name                  = local.resource_name_map[k_table]
      server_side_encryption_enabled = v.server_side_encryption_enabled == null ? var.table_server_side_encryption_enabled_default : v.server_side_encryption_enabled
      table_name                     = local.name_infix_map[k_table] ? local.resource_name_map[k_table] : replace(k_table, "/[_.]/", "-")
      tags = merge(
        var.std_map.tags,
        {
          Name = local.resource_name_map[k_table]
        }
      )
    })
  }
  resource_name_map = {
    for k_table, _ in var.table_map : k_table => "${var.std_map.resource_name_prefix}${replace(k_table, "/[_.]/", "-")}${var.std_map.resource_name_suffix}"
  }
}
