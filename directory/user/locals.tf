locals {
  create_password_map = {
    for k, v in local.lx_map : k => {
      # Named <directory>-user-<key>-password; the secret rotation tool refuses these by that pattern
      name_append  = var.password_secret_name_append_default
      name_prepend = "${v.directory_name}-user"
    }
  }
  l0_map = {
    for k, v in var.user_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      directory_key = v.directory_key == null ? var.user_directory_key_default : v.directory_key
      user_name     = v.user_name == null ? k : v.user_name
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      directory_id   = var.directory_data_map[local.l1_map[k].directory_key].directory_id
      directory_name = var.directory_data_map[local.l1_map[k].directory_key].name_simple
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
        password  = module.password_secret.data[k]
        user_name = terraform_data.this_user[k].output.user_name # Known once the user exists
      }
    )
  }
}
