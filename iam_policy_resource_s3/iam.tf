data "aws_iam_policy_document" "policy_doc" {
  for_each = local.has_policy ? { this = {} } : {}
  dynamic "statement" {
    for_each = local.sid_map
    content {
      actions = var.std_map.service_resource_access_action[local.service_name][statement.value.resource_type][statement.value.access]
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

# This is non-trivial as the AWS API actually checks absurd conditions very well
data "aws_iam_policy_document" "empty_policy" {
  for_each = local.has_policy ? {} : { this = {} }
  statement {
    actions = ["*"]
    condition {
      test     = "IpAddress"
      values   = ["0.0.0.0"]
      variable = "aws:SourceIp"
    }
    effect = "Deny"
    principals {
      identifiers = ["*"]
      type        = "*"
    }
    resources = ["arn:${var.std_map.iam_partition}:s3:::${var.bucket_name}"]
    sid       = "EmptyPolicy"
  }
}

resource "aws_s3_bucket_policy" "this_bucket_policy" {
  bucket = var.bucket_name
  policy = local.policy_json
}
