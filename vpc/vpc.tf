resource "aws_vpc" "this_vpc" {
  for_each                             = local.vpc_map
  assign_generated_ipv6_cidr_block     = each.value.vpc_assign_ipv6_cidr
  cidr_block                           = each.value.vpc_cidr_block
  enable_dns_hostnames                 = true
  enable_dns_support                   = true
  enable_network_address_usage_metrics = false
  instance_tenancy                     = "default"
  ipv4_ipam_pool_id                    = null # TODO
  ipv4_netmask_length                  = null # TODO
  ipv6_cidr_block                      = null # Use netmask
  ipv6_cidr_block_network_border_group = null
  ipv6_ipam_pool_id                    = null # TODO
  ipv6_netmask_length                  = null # TODO
  tags                                 = each.value.tags
}

resource "aws_default_network_acl" "this_default_nacl" {
  for_each               = local.vpc_map
  default_network_acl_id = aws_vpc.this_vpc[each.key].default_network_acl_id
  tags                   = each.value.tags
}

resource "aws_default_route_table" "this_default_route_table" {
  for_each               = local.vpc_map
  default_route_table_id = aws_vpc.this_vpc[each.key].default_route_table_id
  tags                   = each.value.tags
}

resource "aws_default_security_group" "this_default_sg" {
  for_each = local.vpc_map
  tags     = each.value.tags
  vpc_id   = aws_vpc.this_vpc[each.key].id
}
