locals {
  resource_name = "${var.std_map.resource_name_prefix}${replace(var.name, "_", "-")}${var.std_map.resource_name_suffix}"
  vpc_security_group_id_list = [
    for k_sg in var.vpc_security_group_key_list : var.vpc_data.security_group_map[k_sg].id
  ]
  vpc_subnet_id_list = [
    for k_az in var.vpc_subnet_key_list : var.vpc_data.segment_map[var.vpc_segment_key].subnet_map[k_az].subnet_id
  ]
  tags = merge(
    var.std_map.tags,
    {
      Name = local.resource_name
    }
  )
}
