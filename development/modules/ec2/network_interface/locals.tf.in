{{ name.map() }}

module "vpc_map" {
  source                              = "../../vpc/id_map"
  vpc_map                             = local.l0_map
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_key_default                     = var.vpc_key_default
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
  vpc_segment_key_default             = var.vpc_segment_key_default
  vpc_data_map                        = var.vpc_data_map
}

locals {
  l0_map = {
    for k, v in var.interface_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      private_ip_count = v.private_ip_count == null ? var.interface_private_ip_count_default : v.private_ip_count
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      vpc_supports_ipv6 = var.vpc_data_map[local.l1_map[k].vpc_key].vpc_assign_ipv6_cidr
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      ipv6_address_count = local.l2_map[k].vpc_supports_ipv6 ? v.ipv6_address_count == null ? var.interface_ipv6_address_count_default : v.ipv6_address_count : 0
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        interface_arn = aws_network_interface.this_interface[k].arn
        interface_id  = aws_network_interface.this_interface[k].id
      }
    )
  }
}
