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
  create_role_map = {
    for k, v in local.lx_map : k => merge(v, {
      role_policy_attach_arn_map_default = merge(
        {
          log_write = module.log_group.data[k].policy_map["write"].iam_policy_arn
        },
        v.kms_key_policy_arn == null ? {} : {
          encrypt_log_object = v.kms_key_policy_arn
        }
      )
    })
  }
  l0_map = {
    for k, v in var.trail_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      advanced_event_selector_map   = v.advanced_event_selector_map == null ? var.trail_advanced_event_selector_map_default : v.advanced_event_selector_map
      event_selector_map            = v.event_selector_map == null ? var.trail_event_selector_map_default : v.event_selector_map
      include_global_service_events = v.include_global_service_events == null ? var.trail_include_global_service_events_default : v.include_global_service_events
      insight_type_list             = v.insight_type_list == null ? var.trail_insight_type_list_default : v.insight_type_list
      kms_key_key                   = v.kms_key_key == null ? var.trail_kms_key_key_default : v.kms_key_key
      log_bucket_key                = v.log_bucket_key == null ? var.trail_log_bucket_key_default : v.log_bucket_key
      log_bucket_object_prefix      = v.log_bucket_object_prefix == null ? var.trail_log_bucket_object_prefix_default : v.log_bucket_object_prefix
      log_file_validation_enabled   = v.log_file_validation_enabled == null ? var.trail_log_file_validation_enabled_default : v.log_file_validation_enabled
      logging_enabled               = v.logging_enabled == null ? var.trail_logging_enabled_default : v.logging_enabled
      multi_region_trail_enabled    = v.multi_region_trail_enabled == null ? var.trail_multi_region_trail_enabled_default : v.multi_region_trail_enabled
      organization_trail_enabled    = v.organization_trail_enabled == null ? var.trail_organization_trail_enabled_default : v.organization_trail_enabled
      sns_topic_name                = v.sns_topic_name == null ? var.trail_sns_topic_name_default : v.sns_topic_name
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      event_selector_map = {
        for k_event, v_event in local.l1_map[k].event_selector_map : k_event => merge(v_event, {
          data_resource_type                   = v_event.data_resource_type == null ? var.trail_event_selector_data_resource_type_default : v_event.data_resource_type
          data_resource_value_list             = v_event.data_resource_value_list == null ? var.trail_event_selector_data_resource_value_list_default : v_event.data_resource_value_list
          exclude_management_event_source_list = v_event.exclude_management_event_source_list == null ? var.trail_event_selector_exclude_management_event_source_list_default : v_event.exclude_management_event_source_list
          include_management_events            = v_event.include_management_events == null ? var.trail_event_selector_include_management_events_default : v_event.include_management_events
          read_write_type                      = v_event.read_write_type == null ? var.trail_event_selector_read_write_type_default : v_event.read_write_type
        })
      }
      kms_key_arn        = local.l1_map[k].kms_key_key == null ? null : var.kms_data_map[local.l1_map[k].kms_key_key].key_arn
      kms_key_policy_arn = local.l1_map[k].kms_key_key == null ? null : var.kms_data_map[local.l1_map[k].kms_key_key].policy_map["read_write"].iam_policy_arn
      log_bucket_name    = var.s3_data_map[local.l1_map[k].log_bucket_key].name_effective
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
        log       = module.log_group.data[k]
        role      = module.logging_role[k].data
        trail_arn = aws_cloudtrail.this_trail[k].arn
      }
    )
  }
}
