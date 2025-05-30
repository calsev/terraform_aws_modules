module "name_map" {
  source                          = "../../../../name_map"
  name_append_default             = trim("${var.name_append_default}_${var.policy_name_append_default}", "_")
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = trim("${var.name_prefix_default}_${var.policy_name_prefix_default}", "_")
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

locals {
  create_policy_map = {
    for k, v in local.lx_map : k => v if v.policy_create
  }
  l0_map = {
    for k, v in var.policy_map : k => merge(v, {
      name_append = v.name_append == null && v.policy_name_append == null ? null : trim("${v.name_append == null ? "" : v.name_append}_${v.policy_name_append == null ? "" : v.policy_name_append}", "_")
    })
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      policy_create = v.policy_create == null ? var.policy_create_default : v.policy_create
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains(["iam_policy_json"], k_attr)
      },
      {
        iam_policy_doc = jsondecode(v.iam_policy_json)
        iam_policy_arn = v.policy_create ? aws_iam_policy.policy[k].arn : null
      }
    )
  }
}
