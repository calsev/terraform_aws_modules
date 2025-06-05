{{ name.map() }}

locals {
  l0_map = {
    for k, v in var.group_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      key_id_list = [
        for k_key in v.key_key_list : var.key_data_map[k_key].key_id
      ]
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
        group_id = aws_cloudfront_key_group.this_group[k].id
      }
    )
  }
}
