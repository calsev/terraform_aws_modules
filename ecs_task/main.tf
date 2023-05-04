module "this_event_bus" {
  source  = "../event_bus"
  bus_map = local.bus_map
  std_map = var.std_map
}
