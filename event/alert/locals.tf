module "name_map" {
  source   = "../../name_map"
  name_map = local.l0_map
  std_map  = var.std_map
}

locals {
  alert_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  l0_map = {
    for k, v in var.alert_map : "${k}${local.name_append}" => v
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
  name_append = var.name_append == null ? "" : "_${var.name_append}"
  output_data = {
    for k, v in var.alert_map : k => module.alert_trigger.data["${k}${local.name_append}"]
  }
}
