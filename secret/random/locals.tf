locals {
  l0_map = {
    for k, v in var.secret_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      secret_is_param = v.secret_is_param == null ? var.secret_is_param_default : v.secret_is_param
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
        for k_secret, v_secret in v : k_secret => v_secret if !contains([], k_secret)
      },
      v.secret_is_param ? module.this_param.data[k] : null,
      !v.secret_is_param ? module.this_secret.data[k] : null,
      {
      },
    )
  }
  param_map = {
    for k, v in local.lx_map : k => v if v.secret_is_param
  }
  secret_map = {
    for k, v in local.lx_map : k => v if !v.secret_is_param
  }
}
