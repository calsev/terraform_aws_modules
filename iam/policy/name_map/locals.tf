locals {
  l1_map = {
    for k, v in var.name_map : k => merge(v, {
      policy_create       = v.policy_create == null ? var.policy_create_default : v.policy_create
      policy_access_list  = v.policy_access_list == null ? var.policy_access_list_default : v.policy_access_list
      policy_name         = replace(replace(k, var.std_map.name_replace_regex, "-"), "--", "-")
      policy_name_append  = replace(replace(v.policy_name_append == null ? var.policy_name_append_default : v.policy_name_append, var.std_map.name_replace_regex, "-"), "--", "-")
      policy_name_infix   = v.policy_name_infix == null ? var.policy_name_infix_default : v.policy_name_infix
      policy_name_prefix  = replace(replace(v.policy_name_prefix == null ? var.policy_name_prefix_default : v.policy_name_prefix, "/[_.]/", "-"), "--", "-") # Prefix must allow /aws/
      policy_name_prepend = replace(replace(v.policy_name_prepend == null ? var.policy_name_prepend_default : v.policy_name_prepend, var.std_map.name_replace_regex, "-"), "--", "-")
      policy_name_suffix  = replace(replace(v.policy_name_suffix == null ? var.policy_name_suffix_default : v.policy_name_suffix, var.std_map.name_replace_regex, "-"), "--", "-")
    })
  }
  l2_map = {
    for k, _ in var.name_map : k => {
      policy_name_append_expanded  = local.l1_map[k].policy_name_append == "" ? "" : "-${local.l1_map[k].policy_name_append}"
      policy_name_prepend_expanded = local.l1_map[k].policy_name_prepend == "" ? "" : "${local.l1_map[k].policy_name_prepend}-"
    }
  }
  l3_map = {
    for k, v in var.name_map : k => {
      policy_name = local.l1_map[k].policy_create ? v.policy_name == null ? replace("${local.l2_map[k].policy_name_prepend_expanded}${local.l1_map[k].policy_name}${local.l2_map[k].policy_name_append_expanded}", "--", "-") : v.policy_name : null # This controls policy creation
    }
  }
  output_data = {
    for k, v in var.name_map : k => {
      for k_attr, v_attr in merge(local.l1_map[k], local.l2_map[k], local.l3_map[k]) : k_attr => v_attr if !endswith(k_attr, "_expanded")
    }
  }
}
