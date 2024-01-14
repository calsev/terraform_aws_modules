module "bus_policy" {
  source         = "../../iam/policy/identity/event_bus"
  for_each       = local.create_policy_map
  access_list    = each.value.policy_access_list
  event_bus_name = each.value.event_bus_arn
  name           = each.value.policy_name
  name_infix     = each.value.policy_name_infix
  name_prefix    = each.value.policy_name_prefix
  std_map        = var.std_map
}
