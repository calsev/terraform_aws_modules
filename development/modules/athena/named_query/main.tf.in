resource "aws_athena_named_query" "this_query" {
  for_each  = local.lx_map
  name      = each.value.name_effective
  workgroup = each.value.workgroup_id
  database  = each.value.database_id
  query     = each.value.query
}
