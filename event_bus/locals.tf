locals {
  create_archive_map = {
    for k, v in var.bus_map : k => {
      event_bus_arn          = local.event_bus_map[k].event_bus_arn
      resource_name          = local.l2_map[k].resource_name
      archive_retention_days = local.l1_map[k].archive_retention_days
    } if local.l1_map[k].archive_retention_days != null
  }
  create_bus_map = {
    for k, v in var.bus_map : k => {
      resource_name = local.l2_map[k].resource_name
      tags          = local.l3_map[k].tags
    } if v.event_bus_name == null
  }
  create_bus_data_map = {
    for k, v in var.bus_map : k => v if v.event_bus_name != null
  }
  create_schema_map = {
    for k, v in var.bus_map : k => {
      event_bus_arn = local.event_bus_map[k].event_bus_arn
      tags          = local.l3_map[k].tags
    }
  }
  event_bus_map = {
    for k, v in var.bus_map : k => {
      event_bus_arn  = v.event_bus_name == null ? aws_cloudwatch_event_bus.this_bus[k].arn : data.aws_cloudwatch_event_bus.this_bus[k].arn
      event_bus_name = v.event_bus_name == null ? aws_cloudwatch_event_bus.this_bus[k].name : v.event_bus_name
    }
  }
  l1_map = {
    for k, v in var.bus_map : k => {
      archive_retention_days = v.archive_retention_days == null ? var.bus_archive_retention_days_default : v.archive_retention_days
      log_retention_days     = v.log_retention_days == null ? var.bus_log_retention_days_default : v.log_retention_days
      name                   = replace(k, "/_/", "-")
    }
  }
  l2_map = {
    for k, v in var.bus_map : k => {
      log_name      = "bus-${local.l1_map[k].name}"
      resource_name = "${var.std_map.resource_name_prefix}${local.l1_map[k].name}${var.std_map.resource_name_suffix}"
    }
  }
  l3_map = {
    for k, v in var.bus_map : k => {
      tags = merge(
        var.std_map.tags,
        {
          Name = local.l2_map[k].resource_name
        }
      )
    }
  }
  log_map = {
    for k, v in var.bus_map : local.l2_map[k].log_name => {
      create_policy      = false
      log_retention_days = local.l1_map[k].log_retention_days
    } if local.l1_map[k].log_retention_days != null
  }
  log_target_map = {
    for k, v in var.bus_map : local.l2_map[k].log_name => {
      event_bus_name = local.event_bus_map[k].event_bus_name
      log_group_arn  = module.log_group.data[local.l2_map[k].log_name].log_group_arn
    } if local.l1_map[k].log_retention_days != null
  }
  output_data = {
    bus = {
      for k, v in var.bus_map : k => merge(
        v,
        local.l1_map[k],
        local.l2_map[k],
        local.l3_map[k],
        local.event_bus_map[k],
      )
    }
    log     = module.log_group.data
    trigger = module.log_trigger.data
  }
}
