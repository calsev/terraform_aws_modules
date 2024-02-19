module "name_map" {
  source             = "../name_map"
  name_infix_default = var.machine_name_infix_default
  name_map           = var.machine_map
  std_map            = var.std_map
}

module "policy_map" {
  source                      = "../iam/policy/name_map"
  name_map                    = var.machine_map
  policy_access_list_default  = var.policy_access_list_default
  policy_create_default       = var.policy_create_default
  policy_name_append_default  = var.policy_name_append_default
  policy_name_infix_default   = var.policy_name_infix_default
  policy_name_prefix_default  = var.policy_name_prefix_default
  policy_name_prepend_default = var.policy_name_prepend_default
  policy_name_suffix_default  = var.policy_name_suffix_default
  std_map                     = var.std_map
}

locals {
  machine_map = {
    for k, v in var.machine_map : k => merge(v, module.name_map.data[k], module.policy_map.data[k], {
      iam_role_arn = v.iam_role_arn == null ? var.machine_iam_role_arn_default : v.iam_role_arn
      log_level    = v.log_level == null ? var.machine_log_level_default : v.log_level
    })
  }
  output_data = {
    for k, v in local.machine_map : k => merge(
      {
        for k_mach, v_mach in v : k_mach => v_mach if !contains(["definition_json"], k_mach)
      },
      module.machine_policy[k].data,
      {
        arn            = aws_sfn_state_machine.this_machine[k].arn
        definition_doc = jsondecode(v.definition_json)
      },
    )
  }
}
