locals {
  event_bus_arn = var.event_bus_arn != null ? var.event_bus_arn : aws_cloudwatch_event_bus.this_bus["this"].arn
  resource_name = "${var.std_map.resource_name_prefix}${var.name}${var.std_map.resource_name_suffix}"
  tags = merge(
    var.std_map.tags,
    {
      Name = local.resource_name
    }
  )
}
