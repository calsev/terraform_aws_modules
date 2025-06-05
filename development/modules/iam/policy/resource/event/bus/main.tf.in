# This is non-trivial as the AWS API actually checks absurd conditions very well
data "aws_iam_policy_document" "empty_policy" {
  for_each = local.has_empty_policy ? { this = {} } : {}
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
    resources = [local.bus_arn]
    sid       = "EmptyPolicy"
  }
}

module "this_policy" {
  for_each     = local.has_custom_policy ? { this = {} } : {}
  source       = "../../../../../iam/policy/resource/access_resource"
  service_name = local.service_name
  sid_map      = local.sid_map
  std_map      = var.std_map
}

data "aws_iam_policy_document" "final_policy" {
  source_policy_documents = concat(flatten([
    local.has_empty_policy ? [data.aws_iam_policy_document.empty_policy["this"].json] : [],
    local.has_custom_policy ? [jsonencode(module.this_policy["this"].iam_policy_doc)] : [],
  ]))
}

resource "aws_cloudwatch_event_bus_policy" "this_bus_policy" {
  event_bus_name = var.bus_name
  policy         = local.final_policy_json
}
