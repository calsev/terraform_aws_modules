module "initial_value" {
  source     = "../../random/password"
  random_map = local.param_map
  std_map    = var.std_map
}

resource "aws_ssm_parameter" "this_param" {
  for_each        = local.param_map
  allowed_pattern = null
  data_type       = "text"
  insecure_value  = null
  key_id          = each.value.kms_key_id
  lifecycle {
    ignore_changes = [
      value
    ]
  }
  name = each.value.name_effective
  type = "SecureString"
  tags = each.value.tags
  tier = each.value.tier
  value = each.value.secret_random_init_map_final == null ? module.initial_value.secret_map[each.key] : jsonencode(merge(
    each.value.secret_random_init_map_final,
    {
      (each.value.secret_random_init_key) = module.initial_value.secret_map[each.key]
    }
  ))
}
