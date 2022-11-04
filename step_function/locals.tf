locals {
  machine_map = {
    for k, v in var.machine_map : k => merge(v, {
      iam_role_arn = v.iam_role_arn == null ? var.machine_iam_role_arn_default : v.iam_role_arn
      log_level    = v.log_level == null ? var.machine_log_level_default : v.log_level
      name         = local.name_map[k]
      tags = merge(var.std_map.tags, {
        Name = local.name_map[k]
      })
    })
  }
  name_infix_map = {
    for k, v in var.machine_map : k => v.name_infix == null ? var.machine_name_infix_default : v.name_infix
  }
  name_map = {
    for k, v in var.machine_map : k => local.name_infix_map[k] ? "${var.std_map.resource_name_prefix}${replace(k, "/[._]/", "-")}${var.std_map.resource_name_suffix}" : replace(k, "/[._]/", "-")
  }
  output_data = {
    for k, v in local.machine_map : k => merge(
      {
        for k_mach, v_mach in v : k_mach => v_mach if !contains(["definition_json"], k_mach)
      },
      {
        arn            = aws_sfn_state_machine.this_machine[k].arn
        definition_doc = jsondecode(v.definition_json)
      },
    )
  }
}
