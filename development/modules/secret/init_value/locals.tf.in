locals {
  create_init_password_map = {
    for k, v in var.secret_map : k => v if v.secret_random_init_type_is_password
  }
  create_init_tls_key_map = {
    for k, v in var.secret_map : k => v if v.secret_random_init_type_is_ssh_key || v.secret_random_init_type_is_tls_key
  }
  o1_map = {
    for k, v in var.secret_map : k => merge(v, {
      secret_is_key = v.secret_random_init_type_is_ssh_key || v.secret_random_init_type_is_tls_key
    })
  }
  o2_map = {
    for k, v in var.secret_map : k => merge(v, {
      secret_random_init_key = local.o1_map[k].secret_is_key ? "private_key" : v.secret_random_init_key
      secret_random_init_map_default = local.o1_map[k].secret_is_key ? {
        private_key = null
        public_key  = v.secret_random_init_type_is_ssh_key ? module.initial_tls_key.data[k].key_public_openssh : module.initial_tls_key.data[k].key_public_pem
      } : null
    })
  }
  o3_map = {
    for k, v in var.secret_map : k => {
      secret_random_init_map_final = local.o1_map[k].secret_is_key ? local.o2_map[k].secret_random_init_map_default : v.secret_random_init_key == null ? null : merge(
        v.secret_random_init_map == null ? local.o2_map[k].secret_random_init_map_default : v.secret_random_init_map,
        {
          local.o2_map[k].secret_random_init_key = null, # Do not add the secret value here :)
        }
      )
    }
  }
  ox_map = {
    for k, v in var.secret_map : k => merge(local.o1_map[k], local.o2_map[k], local.o3_map[k])
  }
  output_data = {
    for k, v in local.ox_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        password = v.secret_random_init_type_is_password ? module.initial_password.data[k] : null
        tls_key  = v.secret_is_key ? module.initial_tls_key.data[k] : null
      }
    )
  }
  s1_map = {
    for k, v in var.secret_map : k => v.has_random_init_value ? var.secret_random_init_value_map[k] : (
      v.secret_random_init_type_is_password ? module.initial_password.secret_map[k] : (
        v.secret_random_init_type_is_ssh_key ? module.initial_tls_key.secret_map[k].key_private_openssh : (
          v.secret_random_init_type_is_tls_key ? module.initial_tls_key.secret_map[k].key_private_pem : file("Secret must be provided, password, or tls key")
        )
      )
    )
  }
  sx_map = {
    for k, v in var.secret_map : k => local.ox_map[k].secret_random_init_map_final == null ? local.s1_map[k] : jsonencode(merge(
      local.ox_map[k].secret_random_init_map_final,
      {
        (local.ox_map[k].secret_random_init_key) = local.s1_map[k]
      }
    ))
  }
}
