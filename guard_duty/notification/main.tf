module "notification_trigger" {
  source = "../../event/trigger/base"
  event_map = {
    for k, v in local.lx_map : k => {
      event_pattern_json = jsonencode({
        source      = ["aws.guardduty"]
        detail-type = ["GuardDuty Finding"]
      })
      role_policy_attach_arn_map = {
        publish = var.monitor_data.alert.topic_map[var.alert_level_default].policy_map["write"].iam_policy_arn
      }
      target_arn = var.monitor_data.alert.topic_map[var.alert_level_default].topic_arn
    }
  }
  event_target_service_default = "sns"
  monitor_data                 = var.monitor_data
  std_map                      = var.std_map
}
