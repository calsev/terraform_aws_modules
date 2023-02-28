module "default_event_bus" {
  source = "../event_bus"
  bus_map = {
    default = {
      archive_retention_days = 7
      event_bus_name         = "default"
      log_retention_days     = 7
    }
  }
  iam_data = var.iam_data
  std_map  = var.std_map
}
