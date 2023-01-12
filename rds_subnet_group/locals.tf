locals {
  group_map = {
    for k, v in var.group_map : k => merge(v, local.name_map[k], {
      name        = local.name_map[k].name_infix ? local.resource_name_map[k] : local.name_map[k].name
      name_prefix = v.name_prefix == null ? var.group_name_prefix_default : v.name_prefix
      tags = merge(
        var.std_map.tags,
        {
          Name = local.resource_name_map[k]
        }
      )
    })
  }
  name_map = {
    for k, v in var.group_map : k => {
      name       = replace(k, "/[_]/", "-")
      name_infix = v.name_infix == null ? var.group_name_infix_default : v.name_infix
    }
  }
  output_data = {
    for k, v in local.group_map : k => merge(v, {
      arn = aws_db_subnet_group.this_subnet_group[k].arn
      id  = aws_db_subnet_group.this_subnet_group[k].id
    })
  }
  resource_name_map = {
    for k, v in var.group_map : k => "${var.std_map.resource_name_prefix}${local.name_map[k].name}${var.std_map.resource_name_suffix}"
  }
}
