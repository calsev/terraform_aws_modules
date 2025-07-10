module "this_policy" {
  source                          = "../../../../../iam/policy/identity/access_resource"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  policy_access_list_default      = var.policy_access_list_default
  policy_create_default           = var.policy_create_default
  policy_map                      = local.lx_map
  policy_name_append_default      = var.policy_name_append_default
  policy_name_prefix_default      = var.policy_name_prefix_default
  policy_service_name_default     = "sns"
  std_map                         = var.std_map
}
