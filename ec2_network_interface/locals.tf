module "name_map" {
  source   = "../name_map"
  name_map = var.interface_map
  std_map  = var.std_map
}

locals {
  l1_map = {
    for k, v in var.interface_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
    })
  }
  interface_map = {
    for k, v in var.interface_map : k => merge(local.l1_map[k])
  }
  output_data = {
    for k, v in local.interface_map : k => merge(v, {
      nat_eip_id           = aws_eip.nat_eip[k].id
      nat_public_ip        = aws_eip.nat_eip[k].public_ip
      nat_private_ip       = aws_eip.nat_eip[k].private_ip
      network_interface_id = aws_network_interface.this_interface[k].id
    })
  }
}
