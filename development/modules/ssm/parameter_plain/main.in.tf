resource "aws_ssm_parameter" "this_param" {
  for_each        = local.lx_map
  allowed_pattern = each.value.allowed_pattern
  data_type       = each.value.data_type
  insecure_value  = null # This is always dirty
  key_id          = each.value.kms_key_id
  name            = each.value.name_effective
  type            = each.value.type
  tags            = each.value.tags
  tier            = each.value.tier
  value           = each.value.insecure_value
}
