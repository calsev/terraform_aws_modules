{{ name.map() }}

locals {
  l0_map = {
    for k, v in var.pool_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      scaling_mode = v.scaling_mode == null ? var.pool_scaling_mode_default : v.scaling_mode
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
        pool_arn = aws_sesv2_dedicated_ip_pool.this_pool[k].arn
      }
    )
  }
}
