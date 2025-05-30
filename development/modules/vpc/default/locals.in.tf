{{ name.map() }}

locals {
  create_net_map = {
    for k, v in local.lx_map : k => v if v.manage_net
  }
  l0_map = {
    default = {
      manage_net              = var.manage_net_default
      {{ name.var_item(type="null") }}
    }
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
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
}
