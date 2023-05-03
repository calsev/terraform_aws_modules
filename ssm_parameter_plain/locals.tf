module "name_map" {
  source   = "../name_map"
  name_map = var.param_map
  std_map  = var.std_map
}

locals {
  l1_map = {
    for k, v in var.param_map : k => merge(v, module.name_map.data[k], {
      allowed_pattern = v.allowed_pattern == null ? var.param_allowed_pattern_default : v.allowed_pattern
      data_type       = v.data_type == null ? var.param_data_type_default : v.data_type
      kms_key_id      = v.kms_key_id == null ? var.param_kms_key_id_default : v.kms_key_id
      overwrite       = v.overwrite == null ? var.param_overwrite_default : v.overwrite
      tier            = v.tier == null ? var.param_tier_default : v.tier
      type            = v.type == null ? var.param_type_default : v.type
    })
  }
  output_data = {
    for k, v in var.param_map : k => merge(local.param_map[k], {
      secret_arn = aws_ssm_parameter.this_param[k].arn
      secret_id  = aws_ssm_parameter.this_param[k].id
    })
  }
  param_map = {
    for k, v in var.param_map : k => merge(local.l1_map[k])
  }
}
