data "aws_iam_policy_document" "assume_role_policy" {
  dynamic "statement" {
    for_each = local.sid_map
    content {
      actions = local.action_list
      dynamic "condition" {
        for_each = statement.value.condition_map
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
      sid = "${statement.key}AssumeRole"
    }
  }
}
