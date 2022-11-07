locals {
  output_data = {
    for k, v in local.sg_map : k => merge(v, {
      id = aws_security_group.this_sg[k].id
    })
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
    for k, _ in var.security_group_map : k => replace(k, "_", "-")
  }
  sg_name_prefix = "${var.std_map.resource_name_prefix}${var.vpc_data.vpc_name}-"
  sg_name_suffix = var.std_map.resource_name_suffix
  sg_map = {
    for k_sg, v_sg in var.security_group_map : k_sg => {
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
  sg_rule_flattened_list = flatten([for k_sg, v_sg in local.sg_map :
    flatten([for k_rule, v_rule in v_sg.rules : {
      k_sg   = k_sg
      k_rule = k_rule
      v_rule = v_rule
    }])
  ])
  sg_rule_flattened_map = {
    for sg_rule in local.sg_rule_flattened_list : "${replace(sg_rule.k_sg, "_", "-")}-${replace(sg_rule.k_rule, "_", "-")}" => sg_rule
  }
}
