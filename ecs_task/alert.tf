module "alert_trigger" {
  source                = "../event_alert"
  alert_enabled_default = var.alert_enabled_default
  alert_level_default   = var.alert_level_default
  alert_map             = local.task_map
  monitor_data          = var.monitor_data
  std_map               = var.std_map
}
