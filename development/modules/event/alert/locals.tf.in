{{ name.map() }}

locals {
  l0_map = {
    for k, v in var.alert_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      alert_enabled = v.alert_enabled == null ? var.alert_enabled_default : v.alert_enabled
      alert_level   = v.alert_level == null ? var.alert_level_default : v.alert_level
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      is_enabled = local.l1_map[k].alert_enabled # For the target
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains(["alert_event_pattern_json"], k_attr)
      },
      module.alert_trigger.data[k],
      {
      }
    )
  }
}
