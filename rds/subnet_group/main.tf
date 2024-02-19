resource "aws_db_subnet_group" "this_subnet_group" {
  for_each    = local.lx_map
  name        = each.value.name_is_prefix ? null : each.value.name_effective
  name_prefix = each.value.name_is_prefix ? each.value.name_effective : null
  subnet_ids  = each.value.vpc_subnet_id_list
  tags        = each.value.tags
}
