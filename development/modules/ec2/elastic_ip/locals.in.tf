{{ name.map() }}

locals {
  l0_map = {
    for k, v in var.ip_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
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
        eip_allocation_id = aws_eip.this_eip[k].allocation_id
        eip_id            = aws_eip.this_eip[k].id
        eip_public_dns    = aws_eip.this_eip[k].public_dns
        eip_public_ip     = aws_eip.this_eip[k].public_ip
        eip_private_ip    = aws_eip.this_eip[k].private_ip
      }
    )
  }
}
