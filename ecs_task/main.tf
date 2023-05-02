module "this_event_bus" {
  source   = "../event_bus"
  bus_map  = local.bus_map
  iam_data = var.iam_data
  std_map  = var.std_map
}
