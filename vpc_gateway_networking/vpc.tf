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

module "nat_gateway" {
  source        = "../vpc_nat_gateway"
  nat_map       = local.nat_gateway_flattened_map
  subnet_id_map = local.subnet_flattened_id_map
}

module "nat_instance" {
  source         = "../vpc_nat_instance"
  cw_config_data = var.cw_config_data
  nat_map        = local.nat_instance_flattened_map
  std_map        = var.std_map
  vpc_data_map   = local.nat_instance_vpc_data_map
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

resource "aws_route" "internal_to_nat_gateway" {
  for_each               = local.subnet_flattened_nat_gateway_map
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = module.nat_gateway.data[each.value.k_az_nat].nat_gateway_id
  route_table_id         = aws_route_table.this_route_table[each.key].id
}

resource "aws_route" "internal_to_nat_instance" {
  for_each               = local.subnet_flattened_nat_instance_map
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = module.nat_instance.data[each.value.k_az_nat].network_interface_id
  route_table_id         = aws_route_table.this_route_table[each.key].id
}
