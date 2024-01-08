module "repo_policy" {
  for_each    = local.repo_map
  source      = "../iam/policy/identity/ecr"
  name        = each.value.policy_create ? each.value.name_simple : null # Seems terse, but consider the app name and access
  name_infix  = each.value.policy_name_infix
  name_prefix = each.value.policy_name_prefix
  repo_name   = each.value.name_effective
  std_map     = var.std_map
}
