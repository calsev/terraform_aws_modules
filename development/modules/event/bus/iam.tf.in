module "resource_policy" {
  for_each                    = local.event_bus_map
  depends_on                  = [aws_cloudwatch_event_bus.this_bus] # This fails on new buckets
  source                      = "../../iam/policy/resource/event/bus"
  bus_name                    = each.value.event_bus_name
  sid_condition_map_default   = var.sid_condition_map_default
  sid_identifier_list_default = var.sid_identifier_list_default
  sid_identifier_type_default = var.sid_identifier_type_default
  sid_map                     = each.value.sid_map
  std_map                     = var.std_map
}

{{ iam.policy_identity_ar_type(policy_name="bus_policy", suffix="event/bus", map="event_bus_map") }}
