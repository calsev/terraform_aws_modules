locals {
  l1_map = {
    for k, v in var.vpc_map : k => merge(v, {
      vpc_assign_ipv6_cidr = v.vpc_assign_ipv6_cidr == null ? var.vpc_assign_ipv6_cidr_default : v.vpc_assign_ipv6_cidr
      vpc_name             = replace(k, "/_/", "-")
    })
  }
  l2_map = {
    for k, v in var.vpc_map : k => {
      resource_name = "${var.std_map.resource_name_prefix}${local.l1_map[k].vpc_name}${var.std_map.resource_name_suffix}"
    }
  }
  l3_map = {
    for k, v in var.vpc_map : k => {
      tags = merge(
        var.std_map.tags,
        {
          Name = local.l2_map[k].resource_name
        }
      )
    }
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
    for k, v in var.vpc_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
}
