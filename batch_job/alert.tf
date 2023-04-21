module "alert_trigger" {
  source = "../event_trigger"
  event_map = {
    for k, v in local.alert_map : v.k_alert => {
      event_pattern_json = jsonencode(v.alert_event_pattern_doc)
      target_arn         = var.monitor_data.alert.topic_map[v.alert_level].topic_arn
    }
  }
  event_target_service_default = "sns"
  iam_data                     = var.iam_data
  std_map                      = var.std_map
}
