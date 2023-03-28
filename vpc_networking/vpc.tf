resource "aws_internet_gateway" "this_igw" {
  for_each = local.vpc_map
  vpc_id   = each.value.vpc_id
  tags     = each.value.tags
}

resource "aws_egress_only_internet_gateway" "this_eog" {
  for_each = local.eog_map
  vpc_id   = each.value.vpc_id
  tags     = each.value.tags
}

resource "aws_route_table" "this_route_table" {
  for_each = local.subnet_flattened_map
  vpc_id   = each.value.vpc_id
  tags     = each.value.tags
}

resource "aws_route" "public_to_igw" {
  for_each               = local.subnet_flattened_public_map
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this_igw[each.value.k_vpc].id
  route_table_id         = aws_route_table.this_route_table[each.key].id
}

resource "aws_route" "public_to_igw_v6" {
  for_each                    = local.subnet_flattened_public_v6_map
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.this_igw[each.value.k_vpc].id
  route_table_id              = aws_route_table.this_route_table[each.key].id
}

resource "aws_route" "internal_to_eog" {
  for_each                    = local.subnet_flattened_eog_map
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
  ipv6_cidr_block                                = cidrsubnet(each.value.vpc_ipv6_cidr_block, 8, each.value.cidr_block_index) # Must be /64
  ipv6_native                                    = false
  map_customer_owned_ip_on_launch                = null # Cannot be false without other specs
  map_public_ip_on_launch                        = each.value.route_public
  outpost_arn                                    = null
  private_dns_hostname_type_on_launch            = each.value.dns_private_hostname_type
  tags                                           = each.value.tags
  vpc_id                                         = each.value.vpc_id
}

resource "aws_network_acl" "this_nacl" {
  for_each = local.vpc_map
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
  subnet_ids = [for k_az in each.value.k_az_list : aws_subnet.this_subnet[k_az].id]
  tags       = each.value.tags
  vpc_id     = each.value.vpc_id
}

resource "aws_route_table_association" "this_rt_association" {
  for_each       = local.subnet_flattened_map
  subnet_id      = aws_subnet.this_subnet[each.key].id
  route_table_id = aws_route_table.this_route_table[each.key].id
}

resource "aws_eip" "nat_eip" {
  for_each = local.nat_flattened_map
  tags     = each.value.tags
  vpc      = true
}

resource "aws_nat_gateway" "this_nat" {
  for_each          = local.nat_flattened_map
  allocation_id     = aws_eip.nat_eip[each.key].id
  connectivity_type = "public"
  subnet_id         = aws_subnet.this_subnet[each.value.k_az_full].id
  tags              = each.value.tags
  depends_on        = [aws_internet_gateway.this_igw]
}

resource "aws_route" "internal_to_nat" {
  for_each               = local.subnet_flattened_nat_map
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this_nat[each.value.k_az_nat].id
  route_table_id         = aws_route_table.this_route_table[each.key].id
}
