locals {
  has_internal = var.internal_cidr_blocks != null || var.internal_ipv6_cidr_blocks != null
  rule_default_internal = merge(local.rule_default_public, {
    cidr_blocks      = var.internal_cidr_blocks
    ipv6_cidr_blocks = var.internal_ipv6_cidr_blocks
  })
  rule_default_public = {
    cidr_blocks      = var.security_group_cidr_blocks_default
    from_port        = var.security_group_from_port_default
    ipv6_cidr_blocks = var.security_group_ipv6_cidr_blocks_default
    protocol         = var.security_group_protocol_default
    to_port          = var.security_group_to_port_default
    type             = var.security_group_type_default
  }
  rule_map = !local.has_internal ? local.rule_map_public : merge(local.rule_map_public, local.rule_map_internal)
  rule_map_internal = {
    for k_sg, v_sg in var.rule_map_internal : k_sg => {
      rules = {
        for k_rule, v_rule in v_sg.rules : k_rule => {
          cidr_blocks      = local.rule_default_internal.cidr_blocks
          from_port        = v_rule.from_port != null ? v_rule.from_port : local.rule_default_internal.from_port
          ipv6_cidr_blocks = local.rule_default_internal.ipv6_cidr_blocks
          protocol         = v_rule.protocol != null ? v_rule.protocol : local.rule_default_internal.protocol
          to_port          = v_rule.to_port != null ? v_rule.to_port : v_rule.from_port != null ? v_rule.from_port : local.rule_default_internal.to_port
          type             = v_rule.type != null ? v_rule.type : local.rule_default_internal.type
        }
      }
    }
  }
  rule_map_public = {
    for k_sg, v_sg in var.rule_map_public : k_sg => {
      rules = {
        for k_rule, v_rule in v_sg.rules : k_rule => {
          cidr_blocks      = v_rule.cidr_blocks != null ? v_rule.cidr_blocks : local.rule_default_public.cidr_blocks
          from_port        = v_rule.from_port != null ? v_rule.from_port : local.rule_default_public.from_port
          ipv6_cidr_blocks = v_rule.ipv6_cidr_blocks != null ? v_rule.ipv6_cidr_blocks : local.rule_default_public.ipv6_cidr_blocks
          protocol         = v_rule.protocol != null ? v_rule.protocol : local.rule_default_public.protocol
          to_port          = v_rule.to_port != null ? v_rule.to_port : v_rule.from_port != null ? v_rule.from_port : local.rule_default_public.to_port
          type             = v_rule.type != null ? v_rule.type : local.rule_default_public.type
        }
      }
    }
  }
}
