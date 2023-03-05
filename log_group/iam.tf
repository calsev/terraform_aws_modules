module "this_policy" {
  source         = "../iam_policy_identity_log_group"
  for_each       = local.log_map
  log_group_name = aws_cloudwatch_log_group.this_log_group[each.key].name
  name           = each.value.policy_name
  name_infix     = each.value.policy_name_infix
  name_prefix    = each.value.policy_name_prefix
  std_map        = var.std_map
}
