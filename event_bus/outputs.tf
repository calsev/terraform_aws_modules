output "event_bus_arn" {
  value = local.event_bus_arn
}

output "event_bus_name" {
  value = var.event_bus_arn == null ? aws_cloudwatch_event_bus.this_bus["this"].name : null
}
