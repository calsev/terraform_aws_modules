module "name_map" {
  source   = "../../name_map"
  name_map = local.l0_map
  std_map  = var.std_map
}

locals {
  l0_map = {
    for k, v in var.random_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      random_keeper_map  = v.random_keeper_map == null ? var.random_keeper_map_default : v.random_keeper_map
      random_length      = v.random_length == null ? var.random_length_default : v.random_length
      random_min_lower   = v.random_min_lower == null ? var.random_min_lower_default : v.random_min_lower
      random_min_numeric = v.random_min_numeric == null ? var.random_min_numeric_default : v.random_min_numeric
      random_min_special = v.random_min_special == null ? var.random_min_special_default : v.random_min_special
      random_min_upper   = v.random_min_upper == null ? var.random_min_upper_default : v.random_min_upper
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
      }
    )
  }
}
