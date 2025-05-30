{{ name.map() }}

locals {
  l0_map = {
    for k, v in var.vpc_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      vpc_assign_ipv6_cidr = v.vpc_assign_ipv6_cidr == null ? var.vpc_assign_ipv6_cidr_default : v.vpc_assign_ipv6_cidr
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    vpc_map = {
      for k, v in local.lx_map : k => merge(
        {
          for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
        },
        {
          vpc_cidr_block                = aws_vpc.this_vpc[k].cidr_block
          vpc_default_network_acl_id    = aws_vpc.this_vpc[k].default_network_acl_id
          vpc_default_route_table_id    = aws_vpc.this_vpc[k].default_route_table_id
          vpc_default_security_group_id = aws_default_security_group.this_default_sg[k].id
          vpc_id                        = aws_vpc.this_vpc[k].id
          vpc_ipv6_cidr_block           = aws_vpc.this_vpc[k].ipv6_cidr_block
        }
      )
    }
  }
}
