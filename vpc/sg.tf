
resource "aws_security_group" "this_sg" {
  for_each = local.sg_object
  name     = "${local.sg_name_prefix}${local.sg_name[each.key]}${local.sg_name_suffix}"
  tags = merge(
    var.std_map.tags,
    {
      Name = "${local.sg_name_prefix}${local.sg_name[each.key]}${local.sg_name_suffix}"
    }
  )
  vpc_id = aws_vpc.this_vpc.id
}

resource "aws_security_group_rule" "this_sg_rule" {
  for_each          = local.sg_rule_flattened_map
  cidr_blocks       = each.value.v_rule.cidr_blocks
  from_port         = each.value.v_rule.from_port
  ipv6_cidr_blocks  = each.value.v_rule.ipv6_cidr_blocks
  protocol          = each.value.v_rule.protocol
  security_group_id = aws_security_group.this_sg[each.value.k_sg].id
  to_port           = each.value.v_rule.to_port
  type              = each.value.v_rule.type
}
