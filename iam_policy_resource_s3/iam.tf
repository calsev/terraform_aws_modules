module "this_policy" {
  for_each     = local.has_policy ? { this = {} } : {}
  source       = "../iam_policy_resource_access_resource"
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
    resources = ["arn:${var.std_map.iam_partition}:s3:::${var.bucket_name}"]
    sid       = "EmptyPolicy"
  }
}

resource "aws_s3_bucket_policy" "this_bucket_policy" {
  bucket = var.bucket_name
  policy = local.policy_json
}
