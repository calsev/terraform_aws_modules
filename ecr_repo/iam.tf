module "repo_policy" {
  for_each    = local.repo_map
  source      = "../iam_policy_identity_ecr"
  name        = each.value.create_policy ? "ecr-${replace(each.key, "/[_/]/", "-")}" : null # Seems terse, but consider the app name and access
  name_infix  = var.policy_name_infix
  name_prefix = var.policy_name_prefix
  repo_name   = each.value.repo_name
  std_map     = var.std_map
}
