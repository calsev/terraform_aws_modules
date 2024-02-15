module "this_policy" {
  source         = "../../iam/policy/identity/cw/log_group"
  for_each       = local.log_map
  access_list    = each.value.policy_access_list
  log_group_name = aws_cloudwatch_log_group.this_log_group[each.key].name
  name           = each.value.policy_name
  name_infix     = each.value.policy_name_infix
  name_prefix    = each.value.policy_name_prefix
  std_map        = var.std_map
}
