module "vpc_map" {
  source                              = "../vpc_id_map"
  vpc_map                             = var.interface_map
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_key_default                     = var.vpc_key_default
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
  vpc_segment_key_default             = var.vpc_segment_key_default
  vpc_data_map                        = var.vpc_data_map
}

resource "aws_network_interface" "this_interface" {
  for_each          = local.interface_map
  security_groups   = each.value.security_group_id_list
  source_dest_check = false
  subnet_id         = each.value.subnet_id
  tags              = each.value.tags
}

resource "aws_eip" "nat_eip" {
  for_each          = local.interface_map
  network_interface = aws_network_interface.this_interface[each.key].id
  tags              = each.value.tags
  vpc               = true
}
