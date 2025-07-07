module "alarm_map" {
  source              = "../../cw/alarm_map"
  alarm_map           = var.function_map
  alarm_map_default   = var.function_alarm_map_default
  alert_level_default = var.alert_level_default
  monitor_data        = var.monitor_data
  name_map            = module.name_map.data
}

module "name_map" {
  source                          = "../../name_map"
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
  create_alarm_1_list = flatten([
    for k, v in local.lx_map : [
      for k_alarm, v_alarm in v.alarm_map : merge(v, v_alarm, {
        metric_dimension_map = {
          FunctionName = v.lambda_name
        }
        k_all = "${k}_${k_alarm}"
      })
    ]
  ])
  create_alarm_x_map = {
    for v in local.create_alarm_1_list : v.k_all => v
  }
  l0_map = {
    for k, v in var.function_map : k => merge(v, {
      lambda_name = v.name_effective # Preserve before merging name map
    })
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.alarm_map.data[k], {
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
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        alarm = {
          for k_alarm, v_alarm in v.alarm_map : k_alarm => module.alarm.data["${k}_${k_alarm}"]
        }
      },
    )
  }
}
