module "machine_policy" {
  source       = "../iam/policy/identity/step_function/machine"
  for_each     = local.machine_map
  machine_name = each.value.name_effective
  name         = each.value.policy_name
  name_infix   = each.value.policy_name_infix
  name_prefix  = each.value.policy_name_prefix
  access_list  = each.value.policy_access_list
  std_map      = var.std_map
}
