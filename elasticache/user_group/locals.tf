module "name_map" {
  source                          = "../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

module "user_name_map" {
  source                          = "../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.user_x_map
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

locals {
  create_secret_map = {
    # Named <user>-<group>-cache, e.g. messaging-durable-cache-dev-usea1
    for k, v in local.user_x_map : "${v.user_key}_${v.group_key}_cache" => {
      name_include_app_fields = v.name_include_app_fields
      name_infix              = v.name_infix
      secret_random_init_key  = "password"
      secret_random_init_map  = { username = v.user_name }
      secret_random_init_type = "password"
    } if !v.is_default
  }
  create_user_map = {
    for k, v in local.user_x_map : k => merge(v, module.user_name_map.data[k], {
      secret_key = "${v.user_key}_${v.group_key}_cache"
    })
  }
  l0_map = {
    for k, v in var.group_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      engine = v.engine == null ? var.group_engine_default : v.engine
    })
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains(["user_map"], k_attr)
      },
      {
        user_group_id = aws_elasticache_user_group.this_group[k].user_group_id
        user_map = {
          for k_user, _ in v.user_map : k_user => merge(
            module.secret.data["${k_user}_${k}_cache"], # The secret and its policy_map
            {
              user_id   = aws_elasticache_user.this_user["${k}_${k_user}"].user_id
              user_name = aws_elasticache_user.this_user["${k}_${k_user}"].user_name
            },
          )
        }
      }
    )
  }
  user_x_map = merge(
    {
      for k, v in local.l0_map : "${k}_default" => {
        access_string           = var.group_default_user_access_string_default
        engine                  = v.engine == null ? var.group_engine_default : v.engine
        group_key               = k
        is_default              = true
        name_append             = v.name_append
        name_include_app_fields = v.name_include_app_fields
        name_infix              = v.name_infix
        name_prefix             = v.name_prefix
        name_prepend            = v.name_prepend
        name_suffix             = v.name_suffix
        user_key                = "default"
        user_name               = "default"
      }
    },
    {
      for pair in flatten([
        for k, v in local.l0_map : [
          for k_user, v_user in v.user_map : {
            k = "${k}_${k_user}"
            v = {
              access_string           = v_user.access_string
              engine                  = v.engine == null ? var.group_engine_default : v.engine
              group_key               = k
              is_default              = false
              name_append             = v.name_append
              name_include_app_fields = v.name_include_app_fields
              name_infix              = v.name_infix
              name_prefix             = v.name_prefix
              name_prepend            = v.name_prepend
              name_suffix             = v.name_suffix
              user_key                = k_user
              user_name               = k_user
            }
          }
        ]
      ]) : pair.k => pair.v
    },
  )
}
