module "machine_role" {
  source                               = "../iam/role/step_function"
  for_each                             = local.lx_map
  log_data                             = module.log.data[each.key]
  name                                 = "${each.key}_states"
  role_policy_attach_arn_map_default   = var.role_policy_attach_arn_map_default
  role_policy_create_json_map_default  = var.role_policy_create_json_map_default
  role_policy_inline_json_map_default  = var.role_policy_inline_json_map_default
  role_policy_managed_name_map_default = var.role_policy_managed_name_map_default
  role_path_default                    = var.role_path_default
  std_map                              = var.std_map
}

module "machine_policy" {
  source                          = "../iam/policy/identity/step_function/machine"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  policy_access_list_default      = var.policy_access_list_default
  policy_create_default           = var.policy_create_default
  policy_map                      = local.create_policy_map
  policy_name_append_default      = var.policy_name_append_default
  policy_name_prefix_default      = var.policy_name_prefix_default
  std_map                         = var.std_map
}
