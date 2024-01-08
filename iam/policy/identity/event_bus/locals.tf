locals {
  bus_arn = startswith(var.event_bus_name, "arn:") ? var.event_bus_name : "arn:${var.std_map.iam_partition}:events:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:event-bus/${var.event_bus_name}"
}
