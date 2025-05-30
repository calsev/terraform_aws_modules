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
  create_log_map = {
    for k, v in local.lx_map : k => v if length(v.log_destination_arn_list) != 0
  }
  l0_map = {
    for k, v in var.log_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      log_destination_firehose_key_list  = v.log_destination_firehose_key_list == null ? var.log_destination_firehose_key_list_default : v.log_destination_firehose_key_list
      log_destination_log_group_key_list = v.log_destination_log_group_key_list == null ? var.log_destination_log_group_key_list_default : v.log_destination_log_group_key_list
      log_destination_s3_bucket_key_list = v.log_destination_s3_bucket_key_list == null ? var.log_destination_s3_bucket_key_list_default : v.log_destination_s3_bucket_key_list
      log_filter_map                     = v.log_filter_map == null ? var.log_filter_map_default : v.log_filter_map
      log_redacted_field_map             = v.log_redacted_field_map == null ? var.log_redacted_field_map_default : v.log_redacted_field_map
      waf_acl_arn                        = v.waf_acl_arn == null ? var.log_waf_acl_arn_default : v.waf_acl_arn
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      log_destination_arn_list = concat(
        [
          for key in local.l1_map[k].log_destination_firehose_key_list : var.firehose_data_map[key].firehose_arn
        ],
        [
          for key in local.l1_map[k].log_destination_log_group_key_list : var.log_data_map[key].log_group_arn
        ],
        [
          for key in local.l1_map[k].log_destination_s3_bucket_key_list : var.s3_data_map[key].bucket_arn
        ],
      )
      log_filter_map = {
        for k_filter, v_filter in local.l1_map[k].log_filter_map : k_filter => merge(v_filter, {
          default_behavior = v_filter.default_behavior == null ? var.log_filter_default_behavior_default : v.default_behavior
          filter_map       = v_filter.filter_map == null ? var.log_filter_filter_map_default : v_filter.filter_map
        })
      }
      log_redacted_field_map = {
        for k_red, v_red in local.l1_map[k].log_redacted_field_map : k_red => merge(v_red, {
          header_to_redact      = contains(["method", "query_string", "uri_path"], v_red.value) ? null : lower(v_red.value)
          method_redacted       = v_red.value == "method" ? true : false
          query_string_redacted = v_red.value == "query_string" ? true : false
          uri_path_redacted     = v_red.value == "uri_path" ? true : false
        })
      }
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      log_filter_map = {
        for k_filter, v_filter in local.l1_map[k].log_filter_map : k_filter => merge(v_filter, {
          filter_map = {
            for k_f, v_f in v_filter.filter_map : k_f => merge(v_f, {
              behavior      = v_f.behavior == null ? var.log_filter_filter_behavior_default : v_f.behavior
              condition_map = v_f.condition_map == null ? var.log_filter_filter_condition_map_default : v_f.condition_map
              requirement   = v_f.requirement == null ? var.log_filter_filter_requirement_default : v_f.requirement
            })
          }
        })
      }
    }
  }
  l4_map = {
    for k, v in local.l0_map : k => {
      log_filter_map = {
        for k_filter, v_filter in local.l1_map[k].log_filter_map : k_filter => merge(v_filter, {
          filter_map = {
            for k_f, v_f in v_filter.filter_map : k_f => merge(v_f, {
              condition_map = {
                for k_cond, v_cond in v_f.condition_map : k_cond => merge(v_cond, {
                  action     = v_cond.action == null ? var.log_filter_filter_condition_action_default : v_cond.action
                  label_name = v_cond.label_name == null ? var.log_filter_filter_condition_label_name_default : v_cond.label_name
                })
              }
            })
          }
        })
      }
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k], local.l4_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
      }
    )
  }
}
