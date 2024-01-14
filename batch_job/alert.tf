module "alert_trigger" {
  source                = "../event/alert"
  alert_enabled_default = var.alert_enabled_default
  alert_level_default   = var.alert_level_default
  alert_map             = local.job_map
  monitor_data          = var.monitor_data
  std_map               = var.std_map
}
