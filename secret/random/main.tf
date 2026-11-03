module "this_param" {
  source                                      = "../../ssm/parameter_secret"
  name_append_default                         = var.name_append_default
  name_include_app_fields_default             = var.name_include_app_fields_default
  name_infix_default                          = var.name_infix_default
  name_prefix_default                         = var.name_prefix_default
  name_prepend_default                        = var.name_prepend_default
  name_suffix_default                         = var.name_suffix_default
  param_map                                   = local.create_param_map
  policy_access_list_default                  = var.policy_access_list_default
  policy_name_append_default                  = var.policy_name_append_default
  policy_name_prefix_default                  = var.policy_name_prefix_default
  param_secret_random_init_key_default        = var.secret_random_init_key_default
  param_secret_random_init_map_default        = var.secret_random_init_map_default
  param_secret_random_init_type_default       = var.secret_random_init_type_default
  secret_random_init_value_map                = var.secret_random_init_value_map
  secret_random_special_character_set_default = var.secret_random_special_character_set_default
  std_map                                     = var.std_map
}

module "this_secret" {
  source                                      = "../../sm/secret"
  name_append_default                         = var.name_append_default
  name_include_app_fields_default             = var.name_include_app_fields_default
  name_infix_default                          = var.name_infix_default
  name_prefix_default                         = var.name_prefix_default
  name_prepend_default                        = var.name_prepend_default
  name_suffix_default                         = var.name_suffix_default
  policy_access_list_default                  = var.policy_access_list_default
  policy_name_append_default                  = var.policy_name_append_default
  policy_name_prefix_default                  = var.policy_name_prefix_default
  secret_map                                  = local.create_secret_map
  secret_random_init_key_default              = var.secret_random_init_key_default
  secret_random_init_map_default              = var.secret_random_init_map_default
  secret_random_init_type_default             = var.secret_random_init_type_default
  secret_random_init_value_map                = var.secret_random_init_value_map
  secret_random_special_character_set_default = var.secret_random_special_character_set_default
  std_map                                     = var.std_map
}

module "secret_data" {
  source   = "../../secret/data"
  for_each = local.lx_map
  # The ID is unknown until this secret is ready, so a changing secret defers only its own read
  secret_id       = each.value.secret_is_param ? module.this_param.ready_arn_map[each.key] : module.this_secret.ready_arn_map[each.key]
  secret_is_param = each.value.secret_is_param
  secret_key      = each.value.secret_random_init_key
}
