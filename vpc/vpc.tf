resource "aws_vpc" "this_vpc" {
  for_each                         = local.vpc_map
  assign_generated_ipv6_cidr_block = each.value.vpc_assign_ipv6_cidr
  cidr_block                       = each.value.vpc_cidr
  enable_dns_support               = true
  enable_dns_hostnames             = true
  tags                             = each.value.tags
}

resource "aws_internet_gateway" "this_igw" {
  for_each = local.vpc_map
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

resource "aws_subnet" "this_subnet" {
  for_each                = local.subnet_flattened_map
  vpc_id                  = aws_vpc.this_vpc[each.value.k_vpc].id
  cidr_block              = each.value.subnet_cidr
  availability_zone       = each.value.availability_zone_name
  map_public_ip_on_launch = each.value.route_public
  tags                    = each.value.tags
}

resource "aws_route_table_association" "this_rt_association" {
  for_each       = local.subnet_flattened_map
  subnet_id      = aws_subnet.this_subnet[each.key].id
  route_table_id = aws_route_table.this_route_table[each.value.k_seg_full].id
}
