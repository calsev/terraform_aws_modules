module "repo_policy" {
  for_each    = local.lx_map
  source      = "../../iam/policy/identity/ecr"
  access_list = each.value.policy_access_list
  name        = each.value.policy_name
  name_infix  = each.value.policy_name_infix
  name_prefix = each.value.policy_name_prefix
  name_suffix = each.value.policy_name_suffix
  repo_name   = each.value.name_effective
  std_map     = var.std_map
}
