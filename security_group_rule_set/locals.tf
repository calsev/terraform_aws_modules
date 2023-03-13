locals {
  has_internal = var.cidr_blocks_internal != null || var.cidr_blocks_internal_ipv6 != null
  has_private  = var.cidr_blocks_private != null || var.cidr_blocks_private_ipv6 != null
  rule_map     = local.has_internal ? local.has_private ? merge(local.rule_map_public, local.rule_map_internal, local.rule_map_private) : merge(local.rule_map_public, local.rule_map_internal) : local.has_private ? merge(local.rule_map_public, local.rule_map_private) : local.rule_map_public
  rule_map_internal = {
    for k_sg, v_sg in var.rule_map_internal : "internal_${k_sg}" => {
      rules = {
        for k_rule, v_rule in v_sg.rules : k_rule => {
          cidr_blocks      = v_rule.cidr_blocks == null ? var.cidr_blocks_internal : v_rule.cidr_blocks
          from_port        = v_rule.from_port == null ? var.security_group_from_port_default : v_rule.from_port
          ipv6_cidr_blocks = v_rule.ipv6_cidr_blocks == null ? var.cidr_blocks_internal_ipv6 : v_rule.ipv6_cidr_blocks
          protocol         = v_rule.protocol == null ? var.security_group_protocol_default : v_rule.protocol
          to_port          = v_rule.to_port == null ? v_rule.from_port == null ? var.security_group_to_port_default : v_rule.from_port : v_rule.to_port
          type             = v_rule.type == null ? var.security_group_type_default : v_rule.type
        }
      }
    }
  }
  rule_map_public = {
    for k_sg, v_sg in var.rule_map_public : "world_${k_sg}" => {
      rules = {
        for k_rule, v_rule in v_sg.rules : k_rule => {
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
  rule_map_private = {
    for k_sg, v_sg in var.rule_map_private == null ? var.rule_map_internal : var.rule_map_private : "private_${k_sg}" => {
      rules = {
        for k_rule, v_rule in v_sg.rules : k_rule => {
          cidr_blocks      = v_rule.cidr_blocks == null ? var.cidr_blocks_internal : v_rule.cidr_blocks
          from_port        = v_rule.from_port == null ? var.security_group_from_port_default : v_rule.from_port
          ipv6_cidr_blocks = v_rule.ipv6_cidr_blocks == null ? var.cidr_blocks_internal_ipv6 : v_rule.ipv6_cidr_blocks
          protocol         = v_rule.protocol == null ? var.security_group_protocol_default : v_rule.protocol
          to_port          = v_rule.to_port == null ? v_rule.from_port == null ? var.security_group_to_port_default : v_rule.from_port : v_rule.to_port
          type             = v_rule.type == null ? var.security_group_type_default : v_rule.type
        }
      }
    }
  }
}
