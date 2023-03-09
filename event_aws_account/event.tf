module "default_event_bus" {
  source = "../event_bus"
  bus_map = {
    default = {
      archive_retention_days = var.archive_retention_days_for_default_bus
      event_bus_name         = "default"
      logging_enabled        = var.logging_enabled_for_default_bus
      log_retention_days     = var.log_retention_days_for_default_bus
    }
  }
  iam_data = var.iam_data
  std_map  = var.std_map
}
