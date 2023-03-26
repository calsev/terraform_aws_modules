locals {
  group_map = {
    for k, v in var.group_map : k => merge(local.l2_map[k], local.l2_map[k], local.l3_map[k])
  }
  l1_map = {
    for k, v in var.group_map : k => merge(v, module.vpc_map.data[k], {
      name        = replace(k, "/[_]/", "-")
      name_infix  = v.name_infix == null ? var.group_name_infix_default : v.name_infix
      name_prefix = v.name_prefix == null ? var.group_name_prefix_default : v.name_prefix
    })
  }
  l2_map = {
    for k, v in var.group_map : k => {
      resource_name = "${var.std_map.resource_name_prefix}${local.l1_map[k].name}${var.std_map.resource_name_suffix}"
    }
  }
  l3_map = {
    for k, v in var.group_map : k => {
      name = local.l1_map[k].name_infix ? local.l2_map[k].resource_name : local.l1_map[k].name
      tags = merge(
        var.std_map.tags,
        {
          Name = local.l2_map[k].resource_name
        }
      )
    }
  }
  output_data = {
    for k, v in local.group_map : k => merge(v, {
      arn = aws_db_subnet_group.this_subnet_group[k].arn
      id  = aws_db_subnet_group.this_subnet_group[k].id
    })
  }
}
