locals {
  availability_zone_name_list   = data.aws_availability_zones.available.names
  availability_zone_letter_list = ["a", "b", "c", "d", "e", "f"]
  public_segment_name_map       = { for k, segment in var.vpc_data.segment_map : k => {} if segment.route_public }
  resource_name                 = "${var.std_map.resource_name_prefix}${var.vpc_name}${var.std_map.resource_name_suffix}"
  route_table_id_map            = { for k, rt in aws_route_table.this_route_table : k => rt.id }
  security_group_id_object = {
    for k, _ in local.sg_object : k => aws_security_group.this_sg[k].id
  }
  sg_default = {
    cidr_blocks      = var.security_group_cidr_blocks_default
    from_port        = var.security_group_from_port_default
    ipv6_cidr_blocks = var.security_group_ipv6_cidr_blocks_default
    protocol         = var.security_group_protocol_default
    to_port          = var.security_group_to_port_default
    type             = var.security_group_type_default
  }
  sg_name = {
    for k, _ in local.sg_object_root : k => replace(k, "_", "-")
  }
  sg_name_prefix = "${var.std_map.resource_name_prefix}${var.vpc_name}-"
  sg_name_suffix = var.std_map.resource_name_suffix
  sg_object_root = var.vpc_data.security_group_map != null ? var.vpc_data.security_group_map : var.security_group_map_default
  sg_object = {
    for k_sg, v_sg in local.sg_object_root : k_sg => {
      rules = {
        for k_rule, v_rule in v_sg.rules : k_rule => {
          cidr_blocks      = v_rule.cidr_blocks != null ? v_rule.cidr_blocks : local.sg_default.cidr_blocks
          from_port        = v_rule.from_port != null ? v_rule.from_port : local.sg_default.from_port
          ipv6_cidr_blocks = v_rule.ipv6_cidr_blocks != null ? v_rule.ipv6_cidr_blocks : local.sg_default.ipv6_cidr_blocks
          protocol         = v_rule.protocol != null ? v_rule.protocol : local.sg_default.protocol
          to_port          = v_rule.to_port != null ? v_rule.to_port : v_rule.from_port != null ? v_rule.from_port : local.sg_default.to_port
          type             = v_rule.type != null ? v_rule.type : local.sg_default.type
        }
      }
    }
  }
  sg_rule_flattened_list = flatten([for k_sg, v_sg in local.sg_object :
    flatten([for k_rule, v_rule in v_sg.rules : {
      k_sg   = k_sg
      k_rule = k_rule
      v_rule = v_rule
    }])
  ])
  sg_rule_flattened_map = {
    for sg_rule in local.sg_rule_flattened_list : "${replace(sg_rule.k_sg, "_", "-")}-${replace(sg_rule.k_rule, "_", "-")}" => sg_rule
  }
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
