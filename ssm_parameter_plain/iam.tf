module "this_policy" {
  source         = "../iam_policy_identity_secret"
  for_each       = local.param_map
  access_list    = each.value.policy_access_list
  name           = each.value.policy_name
  name_infix     = each.value.policy_name_infix
  name_prefix    = each.value.policy_name_prefix
  ssm_param_name = aws_ssm_parameter.this_param[each.key].name
  std_map        = var.std_map
}
