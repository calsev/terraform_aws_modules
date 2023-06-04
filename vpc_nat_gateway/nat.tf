resource "aws_eip" "this_eip" {
  for_each = var.nat_map
  domain   = "vpc"
  tags     = each.value.tags
}

resource "aws_nat_gateway" "this_nat_gw" {
  for_each          = var.nat_map
  allocation_id     = aws_eip.this_eip[each.key].id
  connectivity_type = "public"
  subnet_id         = var.subnet_id_map[each.value.k_az_full]
  tags              = each.value.tags
}
