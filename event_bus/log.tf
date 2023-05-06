module "log_group" {
  source  = "../log_group"
  log_map = local.log_map
  std_map = var.std_map
}

module "log_trigger" {
  source = "../event_trigger"
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
  std_map                      = var.std_map
}
