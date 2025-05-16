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
  l0_map = {
    for k, v in var.record_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      global_resource_types_included = v.global_resource_types_included == null ? var.record_global_resource_types_included_default : v.global_resource_types_included
      iam_role_arn                   = v.iam_role_arn == null ? var.record_iam_role_arn_default : v.iam_role_arn
      is_enabled                     = v.is_enabled == null ? var.record_is_enabled_default : v.is_enabled
      kms_key_key                    = v.kms_key_key == null ? var.record_kms_key_key_default : v.kms_key_key
      mode_override_map              = v.mode_override_map == null ? var.record_mode_override_map_default : v.mode_override_map
      mode_record_frequency          = v.mode_record_frequency == null ? var.record_mode_record_frequency_default : v.mode_record_frequency
      resource_all_supported_enabled = v.resource_all_supported_enabled == null ? var.record_resource_all_supported_enabled_default : v.resource_all_supported_enabled
      resource_type_list             = v.resource_type_list == null ? var.record_resource_type_list_default : v.resource_type_list
      s3_bucket_key                  = v.s3_bucket_key == null ? var.record_s3_bucket_key_default : v.s3_bucket_key
      s3_object_key_prefix           = v.s3_object_key_prefix == null ? var.record_s3_object_key_prefix_default : v.s3_object_key_prefix
      snapshot_frequency             = v.snapshot_frequency == null ? var.record_snapshot_frequency_default : v.snapshot_frequency
      sns_topic_key                  = v.sns_topic_key == null ? var.record_sns_topic_key_default : v.sns_topic_key
      strategy_use_only              = v.strategy_use_only == null ? var.record_strategy_use_only_default : v.strategy_use_only
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      exclusion_by_resource_type_list = local.l1_map[k].resource_all_supported_enabled ? null : v.exclusion_by_resource_type_list == null ? var.record_exclusion_by_resource_type_list_default : v.exclusion_by_resource_type_list
      kms_key_arn                     = local.l1_map[k].kms_key_key == null ? null : var.kms_data_map[local.l1_map[k].kms_key_key].key_arn
      mode_override_map = {
        for k_mode, v_mode in local.l1_map[k].mode_override_map : k_mode => merge(v_mode, {
          record_frequency   = v_mode.record_frequency == null ? var.record_mode_override_record_frequency_default : v_mode.record_frequency
          resource_type_list = v_mode.resource_type_list == null ? var.record_mode_override_resource_type_list_default : v_mode.resource_type_list
        })
      }
      resource_type_list = local.l1_map[k].resource_all_supported_enabled ? [] : local.l1_map[k].resource_type_list
      s3_bucket_name     = var.s3_data_map[local.l1_map[k].s3_bucket_key].name_effective
      sns_topic_arn      = local.l1_map[k].sns_topic_key == null ? null : var.sns_data.topic_map[local.l1_map[k].sns_topic_key].topic_arn
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
      }
    )
  }
}
