module "name_map" {
  source   = "../name_map"
  name_map = var.vpc_map
  std_map  = var.std_map
}

locals {
  l1_map = {
    for k, v in var.vpc_map : k => merge(v, module.name_map.data[k], {
      vpc_assign_ipv6_cidr = v.vpc_assign_ipv6_cidr == null ? var.vpc_assign_ipv6_cidr_default : v.vpc_assign_ipv6_cidr
    })
  }
  output_data = {
    vpc_map = {
      for k, v in local.vpc_map : k => merge(v, {
        vpc_cidr_block                = aws_vpc.this_vpc[k].cidr_block
        vpc_default_network_acl_id    = aws_default_network_acl.this_default_nacl[k].id
        vpc_default_route_table_id    = aws_default_route_table.this_default_route_table[k].id
        vpc_default_security_group_id = aws_default_security_group.this_default_sg[k].id
        vpc_id                        = aws_vpc.this_vpc[k].id
        vpc_ipv6_cidr_block           = aws_vpc.this_vpc[k].ipv6_cidr_block
      })
    }
  }
  vpc_map = {
    for k, v in var.vpc_map : k => merge(local.l1_map[k])
  }
}
