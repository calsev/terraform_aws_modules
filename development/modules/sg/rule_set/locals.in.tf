locals {
  cidr_blocks_internal_ipv6 = var.cidr_blocks_internal_ipv6 == null ? [for _, v_vpc in var.vpc_map : v_vpc.vpc_ipv6_cidr_block if v_vpc.vpc_ipv6_cidr_block != null] : var.cidr_blocks_internal_ipv6
  has_internal              = var.cidr_blocks_internal != null || var.cidr_blocks_internal_ipv6 != null
  has_private               = var.cidr_blocks_private != null || var.cidr_blocks_private_ipv6 != null
  output_data = {
    security_group_map = local.sg_map
  }
  sg_map = merge(
    local.sg_map_public,
    local.has_internal ? local.sg_map_internal : {},
    local.has_private ? local.sg_map_private : {},
  )
  sg_map_internal = {
    for k_sg, v_sg in var.sg_map_internal : replace("internal_${k_sg}", "/[-]/", "-") => {
      rule_map = {
        for k_rule, v_rule in v_sg.rule_map : replace(k_rule, var.std_map.name_replace_regex, "-") => {
          cidr_blocks      = v_rule.cidr_blocks == null ? var.cidr_blocks_internal : v_rule.cidr_blocks
          from_port        = v_rule.from_port == null ? var.security_group_from_port_default : v_rule.from_port
          ipv6_cidr_blocks = v_rule.ipv6_cidr_blocks == null ? local.cidr_blocks_internal_ipv6 : v_rule.ipv6_cidr_blocks
          protocol         = v_rule.protocol == null ? var.security_group_protocol_default : v_rule.protocol
          to_port          = v_rule.to_port == null ? v_rule.from_port == null ? var.security_group_to_port_default : v_rule.from_port : v_rule.to_port
          type             = v_rule.type == null ? var.security_group_type_default : v_rule.type
        }
      }
    }
  }
  sg_map_public = {
    for k_sg, v_sg in var.sg_map_public : replace("world_${k_sg}", var.std_map.name_replace_regex, "-") => {
      rule_map = {
        for k_rule, v_rule in v_sg.rule_map : replace(k_rule, var.std_map.name_replace_regex, "-") => {
          cidr_blocks      = v_rule.cidr_blocks == null ? var.cidr_blocks_public : v_rule.cidr_blocks
          from_port        = v_rule.from_port == null ? var.security_group_from_port_default : v_rule.from_port
          ipv6_cidr_blocks = v_rule.ipv6_cidr_blocks == null ? var.cidr_blocks_public_ipv6 : v_rule.ipv6_cidr_blocks
          protocol         = v_rule.protocol == null ? var.security_group_protocol_default : v_rule.protocol
          to_port          = v_rule.to_port == null ? v_rule.from_port == null ? var.security_group_to_port_default : v_rule.from_port : v_rule.to_port
          type             = v_rule.type == null ? var.security_group_type_default : v_rule.type
        }
      }
    }
  }
  sg_map_private = {
    for k_sg, v_sg in var.sg_map_private == null ? var.sg_map_internal : var.sg_map_private : replace("private_${k_sg}", var.std_map.name_replace_regex, "-") => {
      rule_map = {
        for k_rule, v_rule in v_sg.rule_map : replace(k_rule, var.std_map.name_replace_regex, "-") => {
          cidr_blocks      = v_rule.cidr_blocks == null ? var.cidr_blocks_internal : v_rule.cidr_blocks
          from_port        = v_rule.from_port == null ? var.security_group_from_port_default : v_rule.from_port
          ipv6_cidr_blocks = v_rule.ipv6_cidr_blocks == null ? local.cidr_blocks_internal_ipv6 : v_rule.ipv6_cidr_blocks
          protocol         = v_rule.protocol == null ? var.security_group_protocol_default : v_rule.protocol
          to_port          = v_rule.to_port == null ? v_rule.from_port == null ? var.security_group_to_port_default : v_rule.from_port : v_rule.to_port
          type             = v_rule.type == null ? var.security_group_type_default : v_rule.type
        }
      }
    }
  }
}
