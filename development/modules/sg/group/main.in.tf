resource "aws_security_group" "this_sg" {
  for_each = local.sg_flattened_map
  name     = each.value.name_effective
  tags     = each.value.tags
  vpc_id   = each.value.vpc_id
}

resource "aws_security_group_rule" "this_sg_rule" {
  for_each          = local.sg_rule_flattened_map
  cidr_blocks       = each.value.cidr_blocks
  from_port         = each.value.from_port
  ipv6_cidr_blocks  = each.value.ipv6_cidr_blocks
  protocol          = each.value.protocol
  security_group_id = aws_security_group.this_sg[each.value.k_sg_full].id
  to_port           = each.value.to_port
  type              = each.value.type
}
