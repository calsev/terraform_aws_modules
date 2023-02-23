locals {
  bus_map = {
    for k, v in var.bus_map : k => merge(v, {
      archive_retention_days = v.archive_retention_days == null ? var.bus_archive_retention_days_default : v.archive_retention_days
      log_retention_days     = v.log_retention_days == null ? var.bus_log_retention_days_default : v.log_retention_days
      log_name               = "bus-${local.name_map[k]}"
      name                   = local.name_map[k]
      resource_name          = local.resource_name_map[k]
      tags = merge(
        var.std_map.tags,
        {
          Name = local.resource_name_map[k]
        }
      )
    })
  }
  create_archive_map = {
    for k, v in local.schema_map : k => v if v.archive_retention_days != null
  }
  create_bus_map = {
    for k, v in local.bus_map : k => v if v.event_bus_name == null
  }
  create_bus_data_map = {
    for k, v in local.bus_map : k => v if v.event_bus_name != null
  }
  log_map = {
    for k, v in local.bus_map : v.log_name => {
      create_policy      = false
      log_retention_days = v.log_retention_days
    } if v.log_retention_days != null
  }
  name_map = {
    for k, v in var.bus_map : k => replace(k, "/_/", "-")
  }
  output_data = {
    bus     = local.schema_map
    log     = module.log_group.data
    trigger = module.log_trigger.data
  }
  schema_map = {
    for k, v in local.bus_map : k => merge(v, {
      event_bus_arn  = v.event_bus_name == null ? aws_cloudwatch_event_bus.this_bus[k].arn : data.aws_cloudwatch_event_bus.this_bus[k].arn
      event_bus_name = v.event_bus_name == null ? aws_cloudwatch_event_bus.this_bus[k].name : v.event_bus_name
    })
  }
  resource_name_map = {
    for k, v in var.bus_map : k => "${var.std_map.resource_name_prefix}${local.name_map[k]}${var.std_map.resource_name_suffix}"
  }
}
