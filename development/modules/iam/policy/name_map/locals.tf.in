locals {
  l1_map = {
    for k, v in var.name_map : k => merge(v, {
      policy_create                  = v.policy_create == null ? var.policy_create_default : v.policy_create
      policy_access_list             = v.policy_access_list == null ? var.policy_access_list_default : v.policy_access_list
      policy_name_append             = v.policy_name_append == null ? var.policy_name_append_default : v.policy_name_append
      policy_name_include_app_fields = v.policy_name_include_app_fields == null ? var.policy_name_include_app_fields_default : v.policy_name_include_app_fields
      policy_name_infix              = v.policy_name_infix == null ? var.policy_name_infix_default : v.policy_name_infix
      policy_name_override           = v.policy_name_override
      policy_name_prefix             = v.policy_name_prefix == null ? var.policy_name_prefix_default : v.policy_name_prefix
      policy_name_prepend            = v.policy_name_prepend == null ? var.policy_name_prepend_default : v.policy_name_prepend
      policy_name_suffix             = v.policy_name_suffix == null ? var.policy_name_suffix_default : v.policy_name_suffix
    })
  }
  l2_map = {
    for k, v in var.name_map : k => {
      policy_name = local.l1_map[k].policy_create ? k : null # This controls policy creation
    }
  }
  output_data = {
    for k, v in var.name_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
}
