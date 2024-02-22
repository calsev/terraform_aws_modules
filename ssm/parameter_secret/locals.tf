module "name_map" {
  source                          = "../../name_map"
  name_include_app_fields_default = var.param_name_include_app_fields_default
  name_infix_default              = var.param_name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = var.param_name_prefix_default
  name_suffix_default             = var.param_name_suffix_default
  std_map                         = var.std_map
}

module "policy_map" {
  source                      = "../../iam/policy/name_map"
  name_map                    = local.l0_map
  policy_access_list_default  = var.policy_access_list_default
  policy_create_default       = var.policy_create_default
  policy_name_append_default  = var.policy_name_append_default
  policy_name_infix_default   = var.policy_name_infix_default
  policy_name_prefix_default  = var.policy_name_prefix_default
  policy_name_prepend_default = var.policy_name_prepend_default
  policy_name_suffix_default  = var.policy_name_suffix_default
  std_map                     = var.std_map
}

module "init_map" {
  source                          = "../../secret/init_map"
  secret_map                      = local.l0_map
  secret_random_init_key_default  = var.param_secret_random_init_key_default
  secret_random_init_map_default  = var.param_secret_random_init_map_default
  secret_random_init_type_default = var.param_secret_random_init_type_default
  secret_random_init_value_map    = var.secret_random_init_value_map
}

locals {
  l0_map = {
    for k, v in var.param_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.policy_map.data[k], module.init_map.data[k], {
      kms_key_id = v.kms_key_id == null ? var.param_kms_key_id_default : v.kms_key_id
      tier       = v.tier == null ? var.param_tier_default : v.tier
    })
  }
  output_data = {
    for k, v in local.param_map : k => merge(
      v,
      {
        init_value = module.initial_value.data[k]
        policy     = module.this_policy[k].data
        secret_arn = aws_ssm_parameter.this_param[k].arn
        secret_id  = aws_ssm_parameter.this_param[k].id
      },
    )
  }
  param_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k])
  }
}
