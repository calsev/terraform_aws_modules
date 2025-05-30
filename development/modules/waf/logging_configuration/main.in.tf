resource "aws_wafv2_web_acl_logging_configuration" "this_config" {
  for_each                = local.create_log_map
  log_destination_configs = each.value.log_destination_arn_list
  dynamic "logging_filter" {
    for_each = each.value.log_filter_map
    content {
      default_behavior = logging_filter.value.default_behavior
      dynamic "filter" {
        for_each = logging_filter.value.filter_map
        content {
          behavior = filter.value.behavior
          dynamic "condition" {
            for_each = filter.value.condition_map
            content {
              dynamic "action_condition" {
                for_each = condition.value.action == null ? {} : { this = {} }
                content {
                  action = condition.value.action
                }
              }
              dynamic "label_name_condition" {
                for_each = condition.value.label_name == null ? {} : { this = {} }
                content {
                  label_name = condition.value.label_name
                }
              }
            }
          }
          requirement = logging_filter.value.requirement
        }
      }
    }
  }
  dynamic "redacted_fields" {
    for_each = each.value.log_redacted_field_map
    content {
      dynamic "method" {
        for_each = redacted_fields.value.method_redacted ? { this = {} } : {}
        content {}
      }
      dynamic "query_string" {
        for_each = redacted_fields.value.query_string_redacted ? { this = {} } : {}
        content {}
      }
      dynamic "single_header" {
        for_each = redacted_fields.value.header_to_redact == null ? {} : { this = {} }
        content {
          name = redacted_fields.value.header_to_redact
        }
      }
      dynamic "uri_path" {
        for_each = redacted_fields.value.uri_path_redacted ? { this = {} } : {}
        content {}
      }
    }
  }
  resource_arn = each.value.waf_acl_arn
}
