resource "aws_elasticache_subnet_group" "this_group" {
  for_each   = local.lx_map
  name       = each.value.name_effective
  subnet_ids = each.value.vpc_subnet_id_list
  tags       = each.value.tags
}
