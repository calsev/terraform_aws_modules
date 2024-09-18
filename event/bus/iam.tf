module "resource_policy" {
  for_each                    = local.create_policy_map
  depends_on                  = [aws_cloudwatch_event_bus.this_bus] # This fails on new buckets
  source                      = "../../iam/policy/resource/event/bus"
  bus_name                    = each.value.event_bus_name
  sid_condition_map_default   = var.sid_condition_map_default
  sid_identifier_list_default = var.sid_identifier_list_default
  sid_identifier_type_default = var.sid_identifier_type_default
  sid_map                     = each.value.sid_map
  std_map                     = var.std_map
}

module "bus_policy" {
  source         = "../../iam/policy/identity/event/bus"
  for_each       = local.create_policy_map
  access_list    = each.value.policy_access_list
  event_bus_name = each.value.event_bus_name
  name           = each.value.policy_name
  name_infix     = each.value.policy_name_infix
  name_prefix    = each.value.policy_name_prefix
  std_map        = var.std_map
}
