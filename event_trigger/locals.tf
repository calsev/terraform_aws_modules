locals {
  batch_array_size     = var.task_count > 1 ? var.task_count : null
  batch_retry_attempts = var.retry_attempts > 0 ? var.retry_attempts : null
  event_bus_name       = var.cron_expression == null ? null : var.event_bus_name
  resource_name        = "${var.std_map.resource_name_prefix}${var.name}${var.std_map.resource_name_suffix}"
  tags = merge(
    var.std_map.tags,
    {
      Name = local.resource_name
    }
  )
}
