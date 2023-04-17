resource "aws_subnet" "this_subnet" {
  for_each                                       = local.subnet_flattened_map
  assign_ipv6_address_on_creation                = each.value.assign_ipv6_address
  availability_zone                              = each.value.availability_zone_name
  cidr_block                                     = each.value.subnet_cidr_block
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

module "gateway_net" {
  source                           = "../vpc_gateway_networking"
  cw_config_data                   = var.cw_config_data
  std_map                          = var.std_map
  vpc_map                          = local.vpc_map
  vpc_nat_gateway_enabled_default  = var.vpc_nat_gateway_enabled_default
  vpc_nat_instance_enabled_default = var.vpc_nat_instance_enabled_default
  vpc_nat_multi_az_default         = var.vpc_nat_multi_az_default
  vpc_subnet_map_data              = module.subnet_map.data
}
