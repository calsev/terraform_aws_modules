module "name_map" {
  source                          = "../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

locals {
  create_archive_map = {
    for k, v in local.event_bus_map : k => v if v.archive_retention_days != null
  }
  create_bus_map = {
    for k, v in local.lx_map : k => v if v.create_bus
  }
  create_bus_data_map = {
    for k, v in local.lx_map : k => v if !v.create_bus
  }
  event_bus_map = {
    for k, v in local.lx_map : k => merge(v, {
      event_bus_arn  = v.create_bus ? aws_cloudwatch_event_bus.this_bus[k].arn : data.aws_cloudwatch_event_bus.this_bus[k].arn
      event_bus_name = v.create_bus ? aws_cloudwatch_event_bus.this_bus[k].name : v.event_bus_name
    })
  }
  l0_map = {
    for k, v in var.bus_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      archive_retention_days        = v.archive_retention_days == null ? var.bus_archive_retention_days_default : v.archive_retention_days
      create_bus                    = v.event_bus_name == null
      logging_enabled               = v.logging_enabled == null ? var.bus_logging_enabled_default : v.logging_enabled
      logging_excluded_detail_types = v.logging_excluded_detail_types == null ? var.bus_logging_excluded_detail_types_default : v.logging_excluded_detail_types
      log_retention_days            = v.log_retention_days == null ? var.bus_log_retention_days_default : v.log_retention_days
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      log_name = "bus_${k}"
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  log_map = {
    for k, v in local.lx_map : v.log_name => merge(v, {
      # Must begin /aws/events: https://aws.amazon.com/premiumsupport/knowledge-center/cloudwatch-log-group-eventbridge/
      name_prefix   = "/aws/events/" # Must be here, rather than default, to overwrite
      policy_create = false
    }) if v.log_retention_days != null
  }
  log_target_map = {
    for k, v in local.event_bus_map : v.log_name => merge(v, {
      log_group_arn = module.log_group.data[local.l2_map[k].log_name].log_group_arn
    }) if v.log_retention_days != null
  }
  output_data = {
    for k, v in local.event_bus_map : k => {
      bus = merge(
        v,
        module.bus_policy.data[k],
        {
          iam_policy_doc = module.resource_policy[k].iam_policy_doc
        },
      )
      log     = module.log_group.data[v.log_name]
      trigger = module.log_trigger.data[v.log_name]
    }
  }
}
