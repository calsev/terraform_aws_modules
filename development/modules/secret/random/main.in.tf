module "this_param" {
  source                                      = "../../ssm/parameter_secret"
  {{ name.map_item() }}
  param_map                                   = local.create_param_map
  {{ iam.policy_map_item_ar() }}
  param_secret_random_init_key_default        = var.secret_random_init_key_default
  param_secret_random_init_map_default        = var.secret_random_init_map_default
  param_secret_random_init_type_default       = var.secret_random_init_type_default
  secret_random_init_value_map                = var.secret_random_init_value_map
  secret_random_special_character_set_default = var.secret_random_special_character_set_default
  std_map                                     = var.std_map
}

module "this_secret" {
  source                                      = "../../sm/secret"
  {{ name.map_item() }}
  {{ iam.policy_map_item_ar() }}
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
  depends_on = [
    module.this_param,
    module.this_secret,
  ]
  secret_key     = each.value.secret_random_init_key
  sm_secret_name = each.value.sm_secret_name
  ssm_param_name = each.value.ssm_param_name
  std_map        = var.std_map
}
