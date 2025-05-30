locals {
  l1_map = {
    for k, v in var.vpc_map : k => merge(v, {
      vpc_az_key_list             = v.vpc_az_key_list == null ? var.vpc_az_key_list_default : v.vpc_az_key_list
      vpc_key                     = v.vpc_key == null ? var.vpc_key_default : v.vpc_key
      vpc_security_group_key_list = v.vpc_security_group_key_list == null ? var.vpc_security_group_key_list_default : v.vpc_security_group_key_list
      vpc_segment_key             = v.vpc_segment_key == null ? var.vpc_segment_key_default : v.vpc_segment_key
    })
  }
  l2_map = {
    for k, v in var.vpc_map : k => {
      vpc_id = local.l1_map[k].vpc_key == null ? null : var.vpc_data_map[local.l1_map[k].vpc_key].vpc_id
      vpc_security_group_id_list = local.l1_map[k].vpc_key == null ? [] : [
        for k_sg in local.l1_map[k].vpc_security_group_key_list : var.vpc_data_map[local.l1_map[k].vpc_key].security_group_id_map[k_sg]
      ]
      vpc_segment_route_public = local.l1_map[k].vpc_key == null ? null : local.l1_map[k].vpc_segment_key == null ? null : var.vpc_data_map[local.l1_map[k].vpc_key].segment_map[local.l1_map[k].vpc_segment_key].route_public
      vpc_subnet_id_list = local.l1_map[k].vpc_key == null ? [] : local.l1_map[k].vpc_segment_key == null ? [] : [
        for k_az in local.l1_map[k].vpc_az_key_list : var.vpc_data_map[local.l1_map[k].vpc_key].segment_map[local.l1_map[k].vpc_segment_key].subnet_id_map[k_az]
      ]
    }
  }
  l3_map = {
    for k, v in var.vpc_map : k => {
      vpc_subnet_id_map = local.l1_map[k].vpc_key == null ? {} : local.l1_map[k].vpc_segment_key == null ? {} : {
        for i_az, k_az in local.l1_map[k].vpc_az_key_list : "${local.l1_map[k].vpc_segment_key}-${k_az}" => local.l2_map[k].vpc_subnet_id_list[i_az]
      }
    }
  }
  output_data = {
    for k, v in var.vpc_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
}
