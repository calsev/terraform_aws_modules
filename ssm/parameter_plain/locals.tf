module "name_map" {
  source                          = "../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
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
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      allowed_pattern = v.allowed_pattern == null ? var.param_allowed_pattern_default : v.allowed_pattern
      data_type       = v.data_type == null ? var.param_data_type_default : v.data_type
      kms_key_id      = v.kms_key_id == null ? var.param_kms_key_id_default : v.kms_key_id
      tier            = v.tier == null ? var.param_tier_default : v.tier
      type            = v.type == null ? var.param_type_default : v.type
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains(["insecure_value"], k_attr)
      },
      module.this_policy.data[k],
      {
        secret_arn = aws_ssm_parameter.this_param[k].arn
        secret_id  = aws_ssm_parameter.this_param[k].id
      },
    )
  }
}
