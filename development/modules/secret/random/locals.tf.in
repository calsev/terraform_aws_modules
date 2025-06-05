{{ name.map() }}

locals {
  create_param_map = {
    for k, v in local.lx_map : k => v if v.secret_is_param
  }
  create_secret_map = {
    for k, v in local.lx_map : k => v if !v.secret_is_param
  }
  l0_map = {
    for k, v in var.secret_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      secret_is_param = v.secret_is_param == null ? var.secret_is_param_default : v.secret_is_param
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      sm_secret_name = local.l1_map[k].secret_is_param ? null : local.l1_map[k].name_effective # Needed for data
      ssm_param_name = local.l1_map[k].secret_is_param ? local.l1_map[k].name_effective : null # Needed for data
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_secret, v_secret in v : k_secret => v_secret if !contains([], k_secret)
      },
      v.secret_is_param ? module.this_param.data[k] : module.this_secret.data[k], # Merge these: the whole point is to obscure the implementation
      {
      },
    )
  }
  sx_map = {
    for k, _ in local.lx_map : k => module.secret_data[k].secret
  }
}
