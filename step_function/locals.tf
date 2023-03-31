module "name_map" {
  source             = "../name_map"
  name_infix_default = var.machine_name_infix_default
  name_map           = var.machine_map
  std_map            = var.std_map
}

locals {
  machine_map = {
    for k, v in var.machine_map : k => merge(v, module.name_map.data[k], {
      iam_role_arn = v.iam_role_arn == null ? var.machine_iam_role_arn_default : v.iam_role_arn
      log_level    = v.log_level == null ? var.machine_log_level_default : v.log_level
    })
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
