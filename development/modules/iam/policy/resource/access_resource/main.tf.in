data "aws_iam_policy_document" "this_policy_doc" {
  dynamic "statement" {
    for_each = var.sid_map
    content {
      actions = var.std_map.service_resource_access_action[var.service_name][statement.value.resource_type][statement.value.access]
      dynamic "condition" {
        for_each = statement.value.condition_map == null ? {} : statement.value.condition_map
        content {
          test     = condition.value.test
          values   = condition.value.value_list
          variable = condition.value.variable
        }
      }
      principals {
        identifiers = statement.value.identifier_list
        type        = statement.value.identifier_type
      }
      resources = statement.value.resource_list
      sid       = statement.value.sid
    }
  }
}
