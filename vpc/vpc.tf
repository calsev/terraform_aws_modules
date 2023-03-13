resource "aws_vpc" "this_vpc" {
  for_each                             = local.vpc_map
  assign_generated_ipv6_cidr_block     = each.value.vpc_assign_ipv6_cidr
  cidr_block                           = each.value.vpc_cidr
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
  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    protocol   = -1
    rule_no    = 100
    to_port    = 0
  }
  egress {
    action          = "allow"
    from_port       = 0
    ipv6_cidr_block = "::/0"
    protocol        = -1
    rule_no         = 101
    to_port         = 0
  }
  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    protocol   = -1
    rule_no    = 100
    to_port    = 0
  }
  ingress {
    action          = "allow"
    from_port       = 0
    ipv6_cidr_block = "::/0"
    protocol        = -1
    rule_no         = 101
    to_port         = 0
  }
  subnet_ids = local.subnet_list_map[each.key]
  tags       = each.value.tags
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

resource "aws_internet_gateway" "this_igw" {
  for_each = local.vpc_map
  vpc_id   = aws_vpc.this_vpc[each.key].id
  tags     = each.value.tags
}

resource "aws_egress_only_internet_gateway" "this_eog" {
  for_each = local.eog_map
  vpc_id   = aws_vpc.this_vpc[each.key].id
  tags     = each.value.tags
}

resource "aws_route_table" "this_route_table" {
  for_each = local.segment_flattened_map
  vpc_id   = aws_vpc.this_vpc[each.value.k_vpc].id
  tags     = each.value.tags
}

resource "aws_route" "public_to_igw" {
  for_each               = local.segment_flattened_public_map
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this_igw[each.value.k_vpc].id
  route_table_id         = aws_route_table.this_route_table[each.key].id
}

resource "aws_route" "public_to_igw_v6" {
  for_each                    = local.segment_flattened_public_v6_map
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.this_igw[each.value.k_vpc].id
  route_table_id              = aws_route_table.this_route_table[each.key].id
}

resource "aws_route" "internal_to_eog" {
  for_each                    = local.segment_flattened_eog_map
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = aws_egress_only_internet_gateway.this_eog[each.value.k_vpc].id
  route_table_id              = aws_route_table.this_route_table[each.key].id
}

resource "aws_subnet" "this_subnet" {
  for_each                                       = local.subnet_flattened_map
  assign_ipv6_address_on_creation                = each.value.assign_ipv6_address
  availability_zone                              = each.value.availability_zone_name
  cidr_block                                     = each.value.cidr_block
  customer_owned_ipv4_pool                       = null
  enable_dns64                                   = each.value.assign_ipv6_address
  enable_resource_name_dns_aaaa_record_on_launch = each.value.assign_ipv6_address
  enable_resource_name_dns_a_record_on_launch    = true
  ipv6_cidr_block                                = cidrsubnet(aws_vpc.this_vpc[each.value.k_vpc].ipv6_cidr_block, 8, each.value.cidr_block_index) # Must be /64
  ipv6_native                                    = false
  map_customer_owned_ip_on_launch                = null # Cannot be false without other specs
  map_public_ip_on_launch                        = each.value.route_public
  outpost_arn                                    = null
  private_dns_hostname_type_on_launch            = each.value.dns_private_hostname_type
  tags                                           = each.value.tags
  vpc_id                                         = aws_vpc.this_vpc[each.value.k_vpc].id
}

resource "aws_route_table_association" "this_rt_association" {
  for_each       = local.subnet_flattened_map
  subnet_id      = aws_subnet.this_subnet[each.key].id
  route_table_id = aws_route_table.this_route_table[each.value.k_seg_full].id
}
