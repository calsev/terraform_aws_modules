resource "aws_backup_selection" "this_selection" {
  for_each = local.lx_map
  dynamic "condition" {
    for_each = each.value.condition_map
    content {
      dynamic "string_equals" {
        for_each = condition.value.string_equal_map
        content {
          key   = string_equals.value.key
          value = string_equals.value.value
        }
      }
      dynamic "string_like" {
        for_each = condition.value.string_like_map
        content {
          key   = string_like.value.key
          value = string_like.value.value
        }
      }
      dynamic "string_not_equals" {
        for_each = condition.value.string_not_equal_map
        content {
          key   = string_not_equals.value.key
          value = string_not_equals.value.value
        }
      }
      dynamic "string_not_like" {
        for_each = condition.value.string_not_like_map
        content {
          key   = string_not_like.value.key
          value = string_not_like.value.value
        }
      }
    }
  }
  iam_role_arn  = each.value.iam_role_arn
  name          = each.value.name_display
  not_resources = each.value.resource_arn_not_match_list
  plan_id       = each.value.plan_id
  resources     = each.value.resource_arn_match_list
  dynamic "selection_tag" {
    for_each = each.value.selection_tag_map
    content {
      key   = selection_tag.value.key
      type  = selection_tag.value.operation_type
      value = selection_tag.value.value
    }
  }
}
