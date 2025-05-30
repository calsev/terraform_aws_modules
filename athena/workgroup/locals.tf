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
    for k, v in var.group_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      byte_scanned_cutoff_per_query      = v.byte_scanned_cutoff_per_query == null ? var.group_byte_scanned_cutoff_per_query_default : v.byte_scanned_cutoff_per_query
      force_destroy_enabled              = v.force_destroy_enabled == null ? var.group_force_destroy_enabled_default : v.force_destroy_enabled
      iam_role_arn_execution             = v.iam_role_arn_execution == null ? var.group_iam_role_arn_execution_default : v.iam_role_arn_execution
      is_enabled                         = v.is_enabled == null ? var.group_is_enabled_default : v.is_enabled
      kms_key_key                        = v.kms_key_key == null ? var.group_kms_key_key_default : v.kms_key_key
      output_s3_bucket_location          = v.output_s3_bucket_location == null ? var.group_output_s3_bucket_location_default : v.output_s3_bucket_location
      publish_cloudwatch_metrics_enabled = v.publish_cloudwatch_metrics_enabled == null ? var.group_publish_cloudwatch_metrics_enabled_default : v.publish_cloudwatch_metrics_enabled
      requester_pays_enabled             = v.requester_pays_enabled == null ? var.group_requester_pays_enabled_default : v.requester_pays_enabled
      selected_engine_version            = v.selected_engine_version == null ? var.group_selected_engine_version_default : v.selected_engine_version
      workgroup_configuration_enforced   = v.workgroup_configuration_enforced == null ? var.group_workgroup_configuration_enforced_default : v.workgroup_configuration_enforced
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      encryption_option = v.encryption_option == null ? var.group_encryption_option_default == null ? local.l1_map[k].kms_key_key == null ? "SSE_S3" : "SSE_KMS" : var.group_encryption_option_default : v.encryption_option
      kms_key_arn       = local.l1_map[k].kms_key_key == null ? null : var.kms_data_map[local.l1_map[k].kms_key_key].key_arn
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
