locals {
  group_map = {
    for k, v in var.group_map : k => merge(local.l2_map[k], local.l2_map[k], local.l3_map[k])
  }
  l1_map = {
    for k, v in var.group_map : k => merge(v, {
      name                = replace(k, "/[_]/", "-")
      name_infix          = v.name_infix == null ? var.group_name_infix_default : v.name_infix
      name_prefix         = v.name_prefix == null ? var.group_name_prefix_default : v.name_prefix
      vpc_subnet_key_list = v.vpc_subnet_key_list == null ? var.group_vpc_subnet_key_list_default : v.vpc_subnet_key_list
    })
  }
  l2_map = {
    for k, v in var.group_map : k => {
      resource_name = "${var.std_map.resource_name_prefix}${local.l1_map[k].name}${var.std_map.resource_name_suffix}"
      vpc_subnet_id_list = [
        for k_az in local.l1_map[k].vpc_subnet_key_list : var.vpc_data.segment_map[local.l1_map[k].vpc_segment_key].subnet_map[k_az].subnet_id
      ]
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
