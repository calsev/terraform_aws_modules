module "this_param" {
  source                                = "../../ssm/parameter_secret"
  param_map                             = local.param_map
  param_name_include_app_fields_default = var.secret_name_include_app_fields_default
  param_name_infix_default              = var.secret_name_infix_default
  param_name_prefix_default             = var.secret_name_prefix_default
  param_name_suffix_default             = var.secret_name_suffix_default
  policy_access_list_default            = var.policy_access_list_default
  policy_create_default                 = var.policy_create_default
  policy_name_append_default            = var.policy_name_append_default
  policy_name_infix_default             = var.policy_name_infix_default
  policy_name_prefix_default            = var.policy_name_prefix_default
  policy_name_prepend_default           = var.policy_name_prepend_default
  policy_name_suffix_default            = var.policy_name_suffix_default
  param_secret_random_init_key_default  = var.secret_random_init_key_default
  param_secret_random_init_map_default  = var.secret_random_init_map_default
  std_map                               = var.std_map
}

module "this_secret" {
  source                                 = "../../sm/secret"
  policy_access_list_default             = var.policy_access_list_default
  policy_create_default                  = var.policy_create_default
  policy_name_append_default             = var.policy_name_append_default
  policy_name_infix_default              = var.policy_name_infix_default
  policy_name_prefix_default             = var.policy_name_prefix_default
  policy_name_prepend_default            = var.policy_name_prepend_default
  policy_name_suffix_default             = var.policy_name_suffix_default
  secret_map                             = local.secret_map
  secret_name_include_app_fields_default = var.secret_name_include_app_fields_default
  secret_name_infix_default              = var.secret_name_infix_default
  secret_name_prefix_default             = var.secret_name_prefix_default
  secret_name_suffix_default             = var.secret_name_suffix_default
  secret_random_init_default             = true
  secret_random_init_key_default         = var.secret_random_init_key_default
  secret_random_init_map_default         = var.secret_random_init_map_default
  std_map                                = var.std_map
}
