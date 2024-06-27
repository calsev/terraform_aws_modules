module "log_group" {
  source                     = "../../cw/log_group"
  log_map                    = local.lx_map
  log_retention_days_default = var.log_retention_days_default
  name_append_default        = "trail"
  std_map                    = var.std_map
}

module "logging_role" {
  source                   = "../../iam/role/base"
  for_each                 = local.lx_map
  assume_role_service_list = ["cloudtrail"]
  name                     = "${each.key}_trail"
  role_policy_attach_arn_map_default = {
    log_write = module.log_group.data[each.key].iam_policy_arn_map["write"]
  }
  std_map = var.std_map
}

resource "aws_cloudtrail" "this_trail" {
  for_each = local.lx_map
  dynamic "advanced_event_selector" {
    for_each = each.value.advanced_event_selector_map
    content {
      dynamic "field_selector" {
        for_each = advanced_event_selector.value
        content {
          ends_with       = field_selector.value.ends_with_list
          equals          = field_selector.value.equal_list
          field           = field_selector.value.field
          not_ends_with   = field_selector.value.not_ends_with_list
          not_equals      = field_selector.value.not_equal_list
          not_starts_with = field_selector.value.not_start_with_list
          starts_with     = field_selector.value.start_with_list
        }
      }
      name = advanced_event_selector.key
    }
  }
  cloud_watch_logs_group_arn = "${module.log_group.data[each.key].log_group_arn}:*"
  cloud_watch_logs_role_arn  = module.logging_role[each.key].data.iam_role_arn
  enable_log_file_validation = each.value.log_file_validation_enabled
  enable_logging             = each.value.logging_enabled
  dynamic "event_selector" {
    for_each = each.value.event_selector_map
    content {
      data_resource {
        type   = event_selector.value.data_resource_type
        values = event_selector.value.data_resource_values
      }
      exclude_management_event_sources = event_selector.value.exclude_management_event_sources
      include_management_events        = event_selector.value.include_management_events
      read_write_type                  = event_selector.value.read_write_type
    }
  }
  include_global_service_events = each.value.include_global_service_events
  dynamic "insight_selector" {
    for_each = toset(each.value.insight_type_list)
    content {
      insight_type = insight_selector.key
    }
  }
  is_multi_region_trail = each.value.multi_region_trail_enabled
  is_organization_trail = each.value.organization_trail_enabled
  kms_key_id            = each.value.kms_key_id
  name                  = each.value.name_effective
  s3_bucket_name        = each.value.log_bucket_name
  s3_key_prefix         = each.value.log_bucket_object_prefix
  sns_topic_name        = each.value.sns_topic_name
  tags                  = each.value.tags
}
