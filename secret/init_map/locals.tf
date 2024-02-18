locals {
  l0_map = {
    for k, v in var.secret_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      secret_random_init     = v.secret_random_init == null ? var.secret_random_init_default : v.secret_random_init
      secret_random_init_key = v.secret_random_init_key == null ? var.secret_random_init_key_default : v.secret_random_init_key
      secret_random_init_map = v.secret_random_init_map == null ? var.secret_random_init_map_default : v.secret_random_init_map
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      secret_random_init_map_final = local.l1_map[k].secret_random_init_key == null ? null : merge(
        local.l1_map[k].secret_random_init_map == null ? {} : local.l1_map[k].secret_random_init_map,
        {
          local.l1_map[k].secret_random_init_key = null, # Do not add the secret value here :)
        }
      )
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
