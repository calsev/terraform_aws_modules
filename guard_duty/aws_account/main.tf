module "detector" {
  source = "../../guard_duty/detector"
  detector_map = {
    all_resources = {}
  }
  std_map = var.std_map
}

module "notification" {
  source       = "../../guard_duty/notification"
  monitor_data = var.monitor_data
  std_map      = var.std_map
}
