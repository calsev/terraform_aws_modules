locals {
  l1_map = {
    for k, v in var.name_map : k => merge(v, {
      create_policy      = v.create_policy == null ? var.create_policy_default : v.create_policy
      policy_access_list = v.policy_access_list == null ? var.policy_access_list_default : v.policy_access_list
      policy_name_infix  = v.policy_name_infix == null ? var.policy_name_infix_default : v.policy_name_infix
      policy_name_prefix = v.policy_name_prefix == null ? var.policy_name_prefix_default : v.policy_name_prefix
    })
  }
  l2_map = {
    for k, _ in var.name_map : k => {
      policy_name = local.l1_map[k].create_policy ? local.l1_map[k].policy_name == null ? "${replace(k, var.std_map.name_replace_regex, "-")}-${var.policy_name_suffix}" : local.l1_map[k].policy_name : null # This controls policy creation
    }
  }
  output_data = {
    for k, v in var.name_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
}
