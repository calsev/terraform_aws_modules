locals {
  l0_map = {
    for k, v in var.secret_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      has_random_init_value   = lookup(var.secret_random_init_value_map, k, null) != null
      secret_random_init_key  = v.secret_random_init_key == null ? var.secret_random_init_key_default : v.secret_random_init_key
      secret_random_init_map  = v.secret_random_init_map == null ? var.secret_random_init_map_default : v.secret_random_init_map
      secret_random_init_type = v.secret_random_init_type == null ? var.secret_random_init_type_default : v.secret_random_init_type
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      secret_random_init                  = local.l1_map[k].secret_random_init_type != null
      secret_random_init_type_is_password = local.l1_map[k].secret_random_init_type == null ? false : local.l1_map[k].secret_random_init_type == "password"
      secret_random_init_type_is_tls_key  = local.l1_map[k].secret_random_init_type == null ? false : local.l1_map[k].secret_random_init_type == "tls_key"
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.l0_map : k => merge(
      {
        for k_attr, v_attr in local.lx_map[k] : k_attr => v_attr if !contains([], k_attr)
      },
      {
      },
    )
  }
}
