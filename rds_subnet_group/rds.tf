resource "aws_db_subnet_group" "this_subnet_group" {
  for_each    = local.group_map
  name        = each.value.name_prefix ? null : each.value.name
  name_prefix = each.value.name_prefix ? each.value.name : null
  subnet_ids  = each.value.subnet_id_list
  tags        = each.value.tags
}
