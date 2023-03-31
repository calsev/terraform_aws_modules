resource "aws_cloudwatch_event_bus" "this_bus" {
  for_each = local.create_bus_map
  name     = each.value.name_effective
  tags     = each.value.tags
}

data "aws_cloudwatch_event_bus" "this_bus" {
  for_each = local.create_bus_data_map
  name     = each.value.event_bus_name
}

resource "aws_cloudwatch_event_archive" "this_archive" {
  for_each         = local.create_archive_map
  name             = each.value.name_effective
  event_source_arn = each.value.event_bus_arn
  retention_days   = each.value.archive_retention_days
}

resource "aws_schemas_discoverer" "this_schema" {
  for_each   = local.event_bus_map
  source_arn = each.value.event_bus_arn
  tags       = each.value.tags
}
