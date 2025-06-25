locals {
  l0_map = {
    for k, v in var.alarm_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      alarm_map = v.alarm_map == null ? var.alarm_map_default : v.alarm_map
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      alarm_map = {
        for k_alarm, v_alarm in local.l1_map[k].alarm_map : k_alarm => merge(v_alarm, {
          alarm_description = format(v_alarm.alarm_description, var.name_map[k].name_effective)
          alarm_name        = format(v_alarm.alarm_name, var.name_map[k].name_effective)
          alert_level       = v_alarm.alert_level == null ? var.alert_level_default : v_alarm.alert_level
        })
      }
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      alarm_map = {
        for k_alarm, v_alarm in local.l2_map[k].alarm_map : k_alarm => merge(v_alarm, {
          alarm_action_target_arn_list = [var.monitor_data.alert.topic_map[v_alarm.alert_level].topic_arn]
        })
      }
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
      },
    )
  }
}
