module "this_policy" {
  for_each     = local.has_policy ? { this = {} } : {}
  source       = "../../../../iam/policy/resource/access_resource"
  service_name = local.service_name
  sid_map      = local.sid_map
  std_map      = var.std_map
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
    resources = [local.bucket_arn]
    sid       = "EmptyPolicy"
  }
}

resource "aws_s3_bucket_policy" "this_bucket_policy" {
  for_each = var.policy_create ? { this = {} } : {}
  bucket   = var.bucket_name
  policy   = local.policy_json
}