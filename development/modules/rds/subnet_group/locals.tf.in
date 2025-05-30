{{ name.map() }}

module "vpc_map" {
  source                  = "../../vpc/id_map"
  vpc_map                 = local.l0_map
  vpc_az_key_list_default = var.vpc_az_key_list_default
  vpc_key_default         = var.vpc_key_default
  vpc_segment_key_default = var.vpc_segment_key_default
  vpc_data_map            = var.vpc_data_map
}

locals {
  l0_map = {
    for k, v in var.group_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      name_is_prefix = v.name_is_prefix == null ? var.name_is_prefix_default : v.name_is_prefix
    })
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      v,
      {
        subnet_group_arn = aws_db_subnet_group.this_subnet_group[k].arn
        subnet_group_id  = aws_db_subnet_group.this_subnet_group[k].id
      },
    )
  }
}
