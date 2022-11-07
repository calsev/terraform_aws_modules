locals {
  availability_zone_name_list   = data.aws_availability_zones.available.names
  availability_zone_letter_list = ["a", "b", "c", "d", "e", "f"]
  public_segment_name_map       = { for k, segment in var.vpc_data.segment_map : k => {} if segment.route_public }
  resource_name                 = "${var.std_map.resource_name_prefix}${var.vpc_name}${var.std_map.resource_name_suffix}"
  route_table_id_map            = { for k, rt in aws_route_table.this_route_table : k => rt.id }
  subnet_id_map = {
    for k_seg, v_seg in local.subnet_map : k_seg => [for _, v_subnet in v_seg : v_subnet.id]
  }
  subnet_map = {
    for k_segment, segment in var.vpc_data.segment_map : k_segment => {
      for i_az, subnet_cidr in segment.subnet_cidr_list : local.availability_zone_name_list[i_az] => {
        cidr = subnet_cidr
        id   = aws_subnet.this_subnet["${k_segment}-${local.availability_zone_letter_list[i_az]}"].id
      }
    }
  }
  subnet_flattened_list = flatten([for k_segment, v_segment in var.vpc_data.segment_map :
    flatten([for i_az, subnet_cidr in v_segment.subnet_cidr_list : {
      availability_zone_name = local.availability_zone_name_list[i_az]
      k_az                   = local.availability_zone_letter_list[i_az]
      k_segment              = k_segment
      route_public           = v_segment.route_public
      subnet_cidr            = subnet_cidr
    }])
  ])
  subnet_flattened_map = {
    for subnet in local.subnet_flattened_list : "${subnet.k_segment}-${subnet.k_az}" => subnet
  }
}
