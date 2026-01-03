resource "aws_athena_named_query" "this_query" {
  for_each  = local.lx_map
  database  = each.value.database_id
  name      = each.value.name_effective
  query     = each.value.query
  region    = var.std_map.aws_region_name
  workgroup = each.value.workgroup_id
}
