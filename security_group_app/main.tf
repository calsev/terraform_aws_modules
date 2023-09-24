module "sg_rule" {
  source                           = "../security_group_rule_set"
  cidr_blocks_internal             = var.cidr_blocks_internal
  cidr_blocks_internal_ipv6        = var.cidr_blocks_internal_ipv6
  cidr_blocks_public               = var.cidr_blocks_public
  cidr_blocks_public_ipv6          = var.cidr_blocks_public_ipv6
  cidr_blocks_private              = var.cidr_blocks_private
  cidr_blocks_private_ipv6         = var.cidr_blocks_private_ipv6
  security_group_from_port_default = var.security_group_from_port_default
  security_group_protocol_default  = var.security_group_protocol_default
  security_group_to_port_default   = var.security_group_to_port_default
  security_group_type_default      = var.security_group_type_default
  sg_map_internal                  = var.sg_map_internal
  sg_map_public                    = var.sg_map_public
  sg_map_private                   = var.sg_map_private
  std_map                          = var.std_map
  vpc_map                          = var.vpc_map
}

module "sg" {
  source = "../security_group"
  vpc_map = {
    (var.vpc_key) = merge(
      var.vpc_map[var.vpc_key],
      {
        security_group_map = module.sg_rule.data.security_group_map
      },
    )
  }
  std_map = var.std_map
}
