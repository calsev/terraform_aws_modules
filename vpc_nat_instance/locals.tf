locals {
  l1_map = {
    for k, v in var.nat_map : k => merge(v, {
      # These are required by compute_map
      image_id                    = v.image_id == null ? var.nat_image_id_default : v.image_id
      instance_storage_gib        = v.instance_storage_gib == null ? var.nat_instance_storage_gib_default : v.instance_storage_gib
      instance_type               = v.instance_type == null ? var.nat_instance_type_default : v.instance_type
      key_name                    = v.key_name == null ? var.nat_key_name_default : v.key_name
      min_instances               = 1
      vpc_az_key_list             = [v.k_az]
      vpc_key                     = v.k_vpc
      vpc_security_group_key_list = [] # All security groups are applied to the ENI
      vpc_segment_key             = v.vpc_segment_key == null ? var.vpc_segment_key_default : v.vpc_segment_key
      user_data_commands          = [] # TODO
      # These are for the ENI
      nat_vpc_security_group_key_list = v.vpc_security_group_key_list == null ? var.vpc_security_group_key_list_default : v.vpc_security_group_key_list
      subnet_id                       = var.vpc_data_map[v.k_vpc].segment_map[v.k_seg].subnet_id_map[v.k_az]
    })
  }
  l2_map = {
    for k, v in var.nat_map : k => {
      security_group_id_list = [
        for k_sg in local.l1_map[k].nat_vpc_security_group_key_list : var.vpc_data_map[local.l1_map[k].k_vpc].security_group_id_map[k_sg]
      ]
    }
  }
  l3_map = {
    for k, v in var.nat_map : k => {
    }
  }
  nat_map = {
    for k, v in var.nat_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
  output_data = {
    for k, v in local.nat_map : k => merge(v, {
      nat_eip_id           = aws_eip.nat_eip[k].id
      nat_public_ip        = aws_eip.nat_eip[k].public_ip
      nat_private_ip       = aws_eip.nat_eip[k].private_ip
      network_interface_id = aws_network_interface.this_interface[k].id
    })
  }
}
