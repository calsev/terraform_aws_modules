module "assume_role_policy" {
  source       = "../../iam/policy/assume_role"
  for_each     = local.assume_role_policy_map
  service_list = each.value
}
