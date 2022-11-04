resource "aws_cloudwatch_event_bus" "this_bus" {
  for_each = var.event_bus_arn == null ? { this = {} } : {}
  name     = local.resource_name
  tags     = local.tags
}

resource "aws_cloudwatch_event_archive" "this_archive" {
  name             = local.resource_name
  event_source_arn = local.event_bus_arn
  retention_days   = var.retention_days
}

resource "aws_schemas_discoverer" "this_schema" {
  source_arn = local.event_bus_arn
  tags       = local.tags
}
