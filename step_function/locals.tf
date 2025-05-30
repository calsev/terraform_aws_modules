module "name_map" {
  source                          = "../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

locals {
  create_log_map = {
    for k, v in local.lx_map : k => merge({
    })
  }
  create_policy_map = {
    for k, v in local.lx_map : k => merge({
      machine_name = each.value.name_effective
    })
  }
  l0_map = {
    for k, v in var.machine_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      log_level = v.log_level == null ? var.machine_log_level_default : v.log_level
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
        for k_attr, v_attr in v : k_attr => v_attr if !contains(["definition_json"], k_attr)
      },
      {
        definition_doc = jsondecode(v.definition_json)
        log            = module.log.data[k]
        machine_arn    = aws_sfn_state_machine.this_machine[k].arn
        policy         = module.machine_policy[k].data
        role           = module.machine_role[k].data
      }
    )
  }
}
