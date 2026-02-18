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

locals {
  create_cw_1_list = flatten([
    for k, v in local.lx_map : [
      for k_log, v_log in v.log_map : merge(v, v_log, {
        k_all = "${k}_${k_log}"
      }) if v_log.cloudwatch_log_key != null
    ]
  ])
  create_cw_2_map = {
    for v in local.create_cw_1_list : v.k_all => v...
  }
  create_cw_x_map = {
    for k, v in local.create_cw_2_map : k => v[0]
  }
  create_log_map = {
    for k, v in local.lx_map : k => merge(v, {
      log_map = {
        for k_log, v_log in v.log_map : k_log => merge(v_log, {
          log_group_arn = v_log.cloudwatch_log_key == null ? null : module.log_group.data["${k}_${k_log}"].log_group_arn
          s3_bucket_arn = v_log.s3_bucket_key == null ? null : var.s3_data_map[v_log.s3_bucket_key].bucket_arn
        })
      }
    })
  }
  l0_map = {
    for k, v in var.pool_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      log_map = v.log_map == null ? var.pool_log_map_default : v.log_map
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      log_map = {
        for k_log, v_log in local.l1_map[k].log_map : k_log => merge(v_log, {
          event_source = v_log.event_source == null ? var.pool_log_event_source_default : v_log.event_source
          log_level    = v_log.log_level == null ? var.pool_log_level_default : v_log.log_level
        })
      }
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
        log_map = {
          for k_log, v_log in v.log_map : k_log => merge(v_log, {
            cw_log = v_log.cloudwatch_log_key == null ? null : module.log_group.data["${k}_${k_log}"]
          })
        }
      },
    )
  }
}
