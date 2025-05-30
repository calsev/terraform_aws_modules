{{ name.map() }}

locals {
  l0_map = {
    for k, v in var.group_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      family        = v.family == null ? var.group_family_default : v.family
      parameter_map = v.parameter_map == null ? var.group_parameter_map_default : v.parameter_map
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
        arn = aws_elasticache_parameter_group.this_group[k].arn
      }
    )
  }
}
