module "machine_role" {
  source                               = "../iam/role/step_function"
  for_each                             = local.lx_map
  log_data                             = module.log.data[each.key]
  name                                 = "${each.key}_states"
  role_policy_attach_arn_map_default   = var.role_policy_attach_arn_map_default
  role_policy_create_json_map_default  = var.role_policy_create_json_map_default
  role_policy_inline_json_map_default  = var.role_policy_inline_json_map_default
  role_policy_managed_name_map_default = var.role_policy_managed_name_map_default
  std_map                              = var.std_map
}

module "machine_policy" {
  source       = "../iam/policy/identity/step_function/machine"
  for_each     = local.lx_map
  machine_name = each.value.name_effective
  name         = each.value.policy_name
  name_infix   = each.value.policy_name_infix
  name_prefix  = each.value.policy_name_prefix
  access_list  = each.value.policy_access_list
  std_map      = var.std_map
}
