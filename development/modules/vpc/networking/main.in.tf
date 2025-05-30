resource "aws_subnet" "this_subnet" {
  for_each                                       = local.subnet_flattened_map
  assign_ipv6_address_on_creation                = each.value.assign_ipv6_address
  availability_zone                              = each.value.availability_zone_name
  cidr_block                                     = each.value.subnet_cidr_block
  customer_owned_ipv4_pool                       = null
  enable_dns64                                   = each.value.dns_v6_enabled
  enable_resource_name_dns_aaaa_record_on_launch = each.value.assign_ipv6_address
  enable_resource_name_dns_a_record_on_launch    = true
  ipv6_cidr_block                                = cidrsubnet(each.value.vpc_ipv6_cidr_block, 8, each.value.cidr_block_index) # Must be /64
  ipv6_native                                    = false
  map_customer_owned_ip_on_launch                = null # Cannot be false without other specs
  map_public_ip_on_launch                        = each.value.assign_public_ip_on_launch
  outpost_arn                                    = null
  private_dns_hostname_type_on_launch            = each.value.dns_private_hostname_type
  tags                                           = each.value.tags
  vpc_id                                         = each.value.vpc_id
}

resource "aws_network_acl" "this_nacl" {
  for_each = local.lx_map
  dynamic "egress" {
    for_each = each.value.nacl_egress_map
    content {
      action          = egress.value.action
      cidr_block      = egress.value.cidr_block
      from_port       = egress.value.from_port
      icmp_code       = egress.value.icmp_code
      icmp_type       = egress.value.icmp_type
      ipv6_cidr_block = egress.value.ipv6_cidr_block
      protocol        = egress.value.protocol
      rule_no         = egress.value.rule_number
      to_port         = egress.value.to_port
    }
  }
  dynamic "ingress" {
    for_each = each.value.nacl_ingress_map
    content {
      action          = ingress.value.action
      cidr_block      = ingress.value.cidr_block
      from_port       = ingress.value.from_port
      icmp_code       = ingress.value.icmp_code
      icmp_type       = ingress.value.icmp_type
      ipv6_cidr_block = ingress.value.ipv6_cidr_block
      protocol        = ingress.value.protocol
      rule_no         = ingress.value.rule_number
      to_port         = ingress.value.to_port
    }
  }
  subnet_ids = [for k_az in each.value.k_az_list : aws_subnet.this_subnet[k_az].id]
  tags       = each.value.tags
  vpc_id     = each.value.vpc_id
}

resource "aws_route_table" "this_route_table" {
  for_each = local.subnet_flattened_map
  vpc_id   = each.value.vpc_id
  tags     = each.value.tags
}

resource "aws_route_table_association" "this_rt_association" {
  for_each       = local.subnet_flattened_map
  subnet_id      = aws_subnet.this_subnet[each.key].id
  route_table_id = aws_route_table.this_route_table[each.key].id
}

resource "aws_internet_gateway" "this_igw" {
  for_each = local.lx_map
  vpc_id   = each.value.vpc_id
  tags     = each.value.tags
}

resource "aws_egress_only_internet_gateway" "this_eog" {
  for_each = local.eog_map
  vpc_id   = each.value.vpc_id
  tags     = each.value.tags
}

module "nat_gateway" {
  source        = "../../vpc/nat_gateway"
  nat_map       = local.nat_gateway_flattened_map
  std_map       = var.std_map
  subnet_id_map = local.subnet_flattened_id_map
}

module "nat_instance" {
  source       = "../../vpc/nat_instance"
  iam_data     = var.iam_data
  monitor_data = var.monitor_data
  nat_map      = local.nat_instance_flattened_map
  std_map      = var.std_map
  vpc_data_map = local.nat_instance_vpc_data_map
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

resource "aws_route" "internal_to_nat_gateway_v6" {
  # This article is for IPv6-only networking, but a long session with an AWS network engineer proved it is necessary for duplex networks
  # https://docs.aws.amazon.com/vpc/latest/userguide/nat-gateway-nat64-dns64.html#nat-gateway-nat64-dns64-walkthrough-internet
  for_each                    = local.subnet_flattened_nat_ipv6_map
  destination_ipv6_cidr_block = "64:ff9b::/96"
  nat_gateway_id              = module.nat_gateway.data[each.value.k_az_nat].nat_gateway_id
  route_table_id              = aws_route_table.this_route_table[each.key].id
}

resource "aws_route" "internal_to_nat_instance" {
  for_each               = local.subnet_flattened_nat_instance_map
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = module.nat_instance.data[each.value.k_az_nat].network_interface_id
  route_table_id         = aws_route_table.this_route_table[each.key].id
}

module "instance_connect_endpoint" {
  source                                      = "../../vpc/instance_connect_endpoint"
  ec2_connect_security_group_key_list_default = var.ec2_connect_security_group_key_list_default
  subnet_data_map = {
    for k, v in local.subnet_flattened_map : k => {
      subnet_id = aws_subnet.this_subnet[k].id
    }
  }
  vpc_map = local.lx_map
}
