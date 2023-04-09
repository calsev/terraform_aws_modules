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
  name  = each.value.name_effective
  type  = "SecureString"
  tags  = each.value.tags
  tier  = each.value.tier
  value = "REPLACE_ME"
}
