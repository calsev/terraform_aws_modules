module "name_map" {
  source   = "../name_map"
  name_map = var.param_map
  std_map  = var.std_map
}

module "policy_map" {
  source                     = "../policy_name_map"
  create_policy_default      = var.param_create_policy_default
  name_map                   = var.param_map
  policy_access_list_default = var.param_policy_access_list_default
  policy_name_infix_default  = var.param_policy_name_infix_default
  policy_name_prefix_default = var.param_policy_name_prefix_default
  policy_name_suffix         = "param"
  std_map                    = var.std_map
}

locals {
  l1_map = {
    for k, v in var.param_map : k => merge(v, module.name_map.data[k], module.policy_map.data[k], {
      allowed_pattern = v.allowed_pattern == null ? var.param_allowed_pattern_default : v.allowed_pattern
      data_type       = v.data_type == null ? var.param_data_type_default : v.data_type
      kms_key_id      = v.kms_key_id == null ? var.param_kms_key_id_default : v.kms_key_id
      overwrite       = v.overwrite == null ? var.param_overwrite_default : v.overwrite
      tier            = v.tier == null ? var.param_tier_default : v.tier
      type            = v.type == null ? var.param_type_default : v.type
    })
  }
  output_data = {
    for k, v in local.param_map : k => merge(
      {
        for k_param, v_param in v : k_param => v_param if !contains(["insecure_value"], k_param)
      },
      module.this_policy[k].data,
      {
        secret_arn = aws_ssm_parameter.this_param[k].arn
        secret_id  = aws_ssm_parameter.this_param[k].id
      },
    )
  }
  param_map = {
    for k, v in var.param_map : k => merge(local.l1_map[k])
  }
}
