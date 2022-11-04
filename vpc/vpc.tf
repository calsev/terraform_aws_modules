resource "aws_vpc" "this_vpc" {
  assign_generated_ipv6_cidr_block = var.vpc_data.vpc_map.assign_ipv6_cidr == null ? var.vpc_assign_ipv6_cidr_default : var.vpc_data.vpc_map.assign_ipv6_cidr
  cidr_block                       = var.vpc_data.vpc_map.cidr
  enable_dns_support               = true
  enable_dns_hostnames             = true

  tags = merge(
    var.std_map.tags,
    {
      Name = local.resource_name
    }
  )
}

resource "aws_internet_gateway" "this_igw" {
  vpc_id = aws_vpc.this_vpc.id

  tags = merge(
    var.std_map.tags,
    {
      Name = local.resource_name
    }
  )
}

resource "aws_route_table" "this_route_table" {
  for_each = var.vpc_data.segment_map
  vpc_id   = aws_vpc.this_vpc.id

  tags = merge(
    var.std_map.tags,
    {
      Name = "${var.std_map.resource_name_prefix}${var.vpc_name}-${each.key}${var.std_map.resource_name_suffix}"
    }
  )
}

resource "aws_route" "public_to_igw" {
  for_each               = local.public_segment_name_map
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this_igw.id
  route_table_id         = aws_route_table.this_route_table[each.key].id
}

resource "aws_subnet" "this_subnet" {
  for_each                = local.subnet_flattened_map
  vpc_id                  = aws_vpc.this_vpc.id
  cidr_block              = each.value.subnet_cidr
  availability_zone       = each.value.availability_zone_name
  map_public_ip_on_launch = each.value.route_public

  tags = merge(
    var.std_map.tags,
    {
      Name = "${var.std_map.resource_name_prefix}${var.vpc_name}-${each.key}${var.std_map.resource_name_suffix}"
    }
  )
}

resource "aws_route_table_association" "this_rt_association" {
  for_each       = local.subnet_flattened_map
  subnet_id      = aws_subnet.this_subnet[each.key].id
  route_table_id = aws_route_table.this_route_table[each.value.k_segment].id
}
