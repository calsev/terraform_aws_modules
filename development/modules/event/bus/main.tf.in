module "log_group" {
  source  = "../../cw/log_group"
  log_map = local.log_map
  std_map = var.std_map
}

module "log_trigger" {
  source = "../../event/trigger/base"
  event_map = {
    for k, v in local.log_target_map : k => {
      event_bus_name = v.event_bus_name
      event_pattern_json = jsonencode({
        account = [
          var.std_map.aws_account_id
        ]
        detail-type = [
          for detail_type in v.logging_excluded_detail_types : {
            anything-but = detail_type
          }
        ]
        # Events come from any service, e.g. aws.events. aws.s3, so omit detail.eventsource and source
      })
      is_enabled = v.logging_enabled
      target_arn = module.log_group.data[k].log_group_arn
    }
  }
  event_target_service_default = "logs"
  monitor_data                 = var.monitor_data
  std_map                      = var.std_map
}

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
