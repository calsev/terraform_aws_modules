resource "aws_glue_connection" "this_connection" {
  for_each = local.lx_map
  # athena_properties
  catalog_id = each.value.catalog_id
  # connection_properties
  connection_type = each.value.connection_type
  match_criteria  = each.value.match_criteria_list
  name            = each.value.name_effective
  physical_connection_requirements {
    availability_zone      = each.value.availability_zone_name
    security_group_id_list = each.value.vpc_security_group_id_list
    subnet_id              = each.value.vpc_subnet_id
  }
  region = var.std_map.aws_region_name
  tags   = each.value.tags
}
