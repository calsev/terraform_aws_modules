module "log_group" {
  source                  = "../log_group"
  log_map                 = local.log_map
  log_name_prefix_default = "/aws/events/" # Must begin /aws/events: https://aws.amazon.com/premiumsupport/knowledge-center/cloudwatch-log-group-eventbridge/
  std_map                 = var.std_map
}

module "log_trigger" {
  source = "../event_trigger"
  event_map = {
    for k, v in local.log_target_map : k => {
      event_bus_name = v.event_bus_name
      target_arn     = module.log_group.data[k].log_group_arn
    }
  }
  event_pattern_json_default = jsonencode({
    account = [
      var.std_map.aws_account_id
    ]
    # Events come from any service, e.g. aws.events. aws.s3, so omit detail.eventsource and source
  })
  event_target_service_default = "logs"
  iam_data                     = var.iam_data
  std_map                      = var.std_map
}
