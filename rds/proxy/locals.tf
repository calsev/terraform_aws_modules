module "name_map" {
  source                          = "../../name_map"
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = var.name_prefix_default
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

module "vpc_map" {
  source                              = "../../vpc/id_map"
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_data_map                        = var.vpc_data_map
  vpc_key_default                     = var.vpc_key_default
  vpc_map                             = local.l0_map
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
  vpc_segment_key_default             = var.vpc_segment_key_default
}

locals {
  create_proxy_map = {
    for k, v in local.lx_map : k => v if v.create_instance
  }
  create_target_1_list = flatten([
    for v in local.create_target_group_2_list : [
      for k_targ, v_targ in v.target_map : [
        merge(v, v_targ, {
          k_targ     = k_targ
          k_targ_all = "${v.k_group_all}_${k_targ}"
        })
      ]
    ]
  ])
  create_target_x_map = {
    for k, v in local.create_target_1_list : v.k_targ_all => v if v.create_instance
  }
  create_target_group_1_map = {
    for k, v in local.lx_map : k => {
      for k_group, v_group in v.target_group_map : k_group => merge(v, v_group, {
        k_group     = k_group
        k_group_all = "${k}_${k_group}"
        k_proxy     = k
      })
    }
  }
  create_target_group_2_list = flatten([
    for k, v in local.create_target_group_1_map : [
      for k_group, v_group in v : v_group
    ]
  ])
  create_target_group_x_map = {
    for k, v in local.create_target_group_2_list : v.k_group_all => v if v.create_instance
  }
  l0_map = {
    for k, v in var.proxy_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      auth_client_password_type   = v.auth_client_password_type == null ? var.proxy_auth_client_password_type_default : v.xauth_client_password_type
      auth_iam_required           = v.auth_iam_required == null ? var.proxy_auth_iam_required_default : v.auth_iam_required
      auth_username               = v.auth_username == null ? var.proxy_auth_username_default : v.auth_username
      create_instance             = v.create_instance == null ? var.proxy_create_instance_default : v.create_instance
      debug_logging_enabled       = v.debug_logging_enabled == null ? var.proxy_debug_logging_enabled_default : v.debug_logging_enabled
      engine_family               = v.engine_family == null ? var.proxy_engine_family_default : v.engine_family
      iam_role_arn                = v.iam_role_arn == null ? var.proxy_iam_role_arn_default : v.iam_role_arn
      idle_client_timeout_seconds = v.idle_client_timeout_seconds == null ? var.proxy_idle_client_timeout_seconds_default : v.idle_client_timeout_seconds
      target_group_map = {
        for k_group, v_group in v.target_group_map : k_group => merge(v_group, {
          connection_borrow_timeout_seconds = v_group.connection_borrow_timeout_seconds == null ? var.proxy_target_connection_borrow_timeout_seconds_default : v_group.connection_borrow_timeout_seconds
          target_map = {
            for k_targ, v_targ in v_group.target_map : k_targ => merge(v_targ, {
              db_key = v_targ.db_key == null ? k_targ : v_targ.db_key
            })
          }
          init_query                  = v_group.init_query == null ? var.proxy_target_init_query_default : v_group.init_query
          max_target_percent          = v_group.max_target_percent == null ? var.proxy_target_max_target_percent_default : v_group.max_target_percent
          max_idle_percent            = v_group.max_idle_percent == null ? var.proxy_target_max_idle_percent_default : v_group.max_idle_percent
          session_pinning_filter_list = v_group.session_pinning_filter_list == null ? var.proxy_target_session_pinning_filter_list_default : v_group.session_pinning_filter_list
        })
      }
      tls_required = v.tls_required == null ? var.proxy_tls_required_default : v.tls_required
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      target_group_map = {
        for k_group, v_group in local.l1_map[k].target_group_map : k_group => merge(v_group, {
          target_map = {
            for k_targ, v_targ in local.l1_map[k].target_group_map[k_group].target_map : k_targ => merge(v_targ, {
              db_name_effective = var.db_data_map[v_targ.db_key].name_effective
            })
          }
        })
      }
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
        proxy_arn      = v.create_instance ? aws_db_proxy.this_proxy[k].arn : null
        proxy_endpoint = v.create_instance ? aws_db_proxy.this_proxy[k].endpoint : null
        proxy_name     = v.create_instance ? aws_db_proxy.this_proxy[k].name : null
        target_group_map = {
          for k_group, v_group in local.lx_map[k].target_group_map : k_group => merge(v_group, {
            target_map = {
              for k_targ, v_targ in v_group.target_map : k_targ => merge(v_targ, {
                target_endpoint = v.create_instance ? aws_db_proxy_target.this_target["${k}_${k_group}_${k_targ}"].endpoint : null
              })
            }
          })
        }
      }
    )
  }
}
