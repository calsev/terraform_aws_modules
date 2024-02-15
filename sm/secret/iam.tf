module "this_policy" {
  source         = "../../iam/policy/identity/secret"
  for_each       = local.secret_map
  access_list    = each.value.policy_access_list
  name           = each.value.policy_name
  name_infix     = each.value.policy_name_infix
  name_prefix    = each.value.policy_name_prefix
  sm_secret_name = aws_secretsmanager_secret.this_secret[each.key].name
  std_map        = var.std_map
}
