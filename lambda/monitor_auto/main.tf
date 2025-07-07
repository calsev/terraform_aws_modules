data "external" "untagged_lambdas" {
  program = flatten([
    "python",
    "${path.module}/list_untagged_lambdas.py",
    flatten([for tag in var.tag_filter_list : ["--tag", tag]]),
  ])
}

module "alarm" {
  source                          = "../../lambda/monitor"
  alert_level_default             = var.alert_level_default
  function_alarm_map_default      = var.function_alarm_map_default
  function_map                    = local.untagged_lambda_x_map
  monitor_data                    = var.monitor_data
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}
