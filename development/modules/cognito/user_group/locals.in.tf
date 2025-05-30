{{ name.map() }}

locals {
  l0_list = flatten([
    for k, v in var.pool_map : [
      for k_g, v_g in v.group_map == null ? var.pool_group_map_default : v.group_map : merge(v, v_g, {
        k_all = "${k}_${k_g}"
      })
    ]
  ])
  l0_map = {
    for v in local.l0_list : v.k_all => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      iam_role_arn = v.iam_role_arn == null ? var.pool_group_iam_role_arn_default : v.iam_role_arn
      precedence   = v.precedence == null ? var.pool_group_precedence_default : v.precedence
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
    for k, v in var.pool_map : k => {
      for k_g, v_g in v.group_map == null ? var.pool_group_map_default : v.group_map : k_g => merge(
        {
          for k_attr, v_attr in local.lx_map["${k}_${k_g}"] : k_attr => v_attr if !contains([], k_attr)
        },
        {
        }
      )
    }
  }
}
