module "name_map" {
  source             = "../name_map"
  name_infix_default = var.group_name_infix_default
  name_map           = var.group_map
  std_map            = var.std_map
}

locals {
  group_map = {
    for k, v in var.group_map : k => merge(local.l1_map[k])
  }
  l1_map = {
    for k, v in var.group_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      name_is_prefix = v.name_is_prefix == null ? var.group_name_is_prefix_default : v.name_is_prefix
    })
  }
  output_data = {
    for k, v in local.group_map : k => merge(v, {
      subnet_group_arn = aws_db_subnet_group.this_subnet_group[k].arn
      subnet_group_id  = aws_db_subnet_group.this_subnet_group[k].id
    })
  }
}
