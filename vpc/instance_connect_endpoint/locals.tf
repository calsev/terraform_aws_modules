locals {
  create_ice_map = {
    for k, v in local.lx_map : v.k_az_full => v
  }
  l0_map = {
    for k, v in var.vpc_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      ec2_connect_security_group_key_list = v.ec2_connect_security_group_key_list == null ? var.ec2_connect_security_group_key_list_default : v.ec2_connect_security_group_key_list
      k_az                                = v.availability_zone_map_key_list[0]
      k_seg                               = v.non_public_segment_list[0]
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      ec2_connect_security_group_id_list = [
        for k_sg in local.l1_map[k].ec2_connect_security_group_key_list : var.vpc_map[k].security_group_id_map[k_sg]
      ]
      k_az_full = "${k}_${local.l1_map[k].k_seg}_${local.l1_map[k].k_az}"
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      subnet_id = var.subnet_data_map[local.l2_map[k].k_az_full].subnet_id
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        instance_connect_arn                       = aws_ec2_instance_connect_endpoint.connect_endpoint[v.k_az_full].arn
        instance_connect_dns_name                  = aws_ec2_instance_connect_endpoint.connect_endpoint[v.k_az_full].dns_name
        instance_connect_fips_dns_name             = aws_ec2_instance_connect_endpoint.connect_endpoint[v.k_az_full].fips_dns_name
        instance_connect_network_interface_id_list = aws_ec2_instance_connect_endpoint.connect_endpoint[v.k_az_full].network_interface_ids
      }
    )
  }
}
