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

module "bus_policy" {
  source                          = "../../iam/policy/identity/event/bus"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  policy_access_list_default      = var.policy_access_list_default
  policy_create_default           = var.policy_create_default
  policy_map                      = local.event_bus_map
  policy_name_append_default      = var.policy_name_append_default
  policy_name_prefix_default      = var.policy_name_prefix_default
  std_map                         = var.std_map
}
