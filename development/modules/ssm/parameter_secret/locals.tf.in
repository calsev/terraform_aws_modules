{{ name.map() }}

module "init_map" {
  source                          = "../../secret/init_map"
  secret_map                      = local.l0_map
  secret_random_init_key_default  = var.param_secret_random_init_key_default
  secret_random_init_map_default  = var.param_secret_random_init_map_default
  secret_random_init_type_default = var.param_secret_random_init_type_default
  secret_random_init_value_map    = var.secret_random_init_value_map
}

locals {
  create_policy_map = {
    for k, v in local.lx_map : k => merge(v, {
      ssm_param_name = aws_ssm_parameter.this_param[k].name
    })
  }
  l0_map = {
    for k, v in var.param_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.init_map.data[k], {
      kms_key_id = v.kms_key_id == null ? var.param_kms_key_id_default : v.kms_key_id
      tier       = v.tier == null ? var.param_tier_default : v.tier
    })
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      v,
      module.this_policy.data[k], # This is just the iam maps
      {
        init_value = module.initial_value.data[k]
        secret_arn = aws_ssm_parameter.this_param[k].arn
        secret_id  = aws_ssm_parameter.this_param[k].id
      },
    )
  }
}
