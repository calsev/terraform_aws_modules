module "alert_trigger" {
  source = "../../event/trigger/base"
  event_map = {
    for k, v in local.alert_map : k => merge(v, {
      event_pattern_json                = v.alert_event_pattern_json
      input_transformer_path_map        = v.alert_target_path_map
      input_transformer_template_string = v.alert_target_template
      target_arn                        = var.monitor_data.alert.topic_map[v.alert_level].topic_arn
    })
  }
  event_target_service_default = "sns"
  std_map                      = var.std_map
}
