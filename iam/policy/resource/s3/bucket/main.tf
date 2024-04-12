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
    resources = [local.bucket_arn]
    sid       = "EmptyPolicy"
  }
}

data "aws_iam_policy_document" "ap_policy" {
  for_each = var.allow_access_point ? { this = {} } : {}
  statement {
    actions = ["*"]
    condition {
      test     = "StringEquals"
      values   = [var.std_map.aws_account_id]
      variable = "s3:DataAccessPointAccount"
    }
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    resources = [
      local.bucket_arn,
      "${local.bucket_arn}/*"
    ]
    sid = "AccessPointDelegation"
  }
}

data "aws_elb_service_account" "lb" {}

data "aws_iam_policy_document" "elb_policy" {
  for_each = var.allow_elb_logging ? { this = {} } : {}
  statement {
    actions = ["s3:PutObject"]
    principals {
      identifiers = [data.aws_elb_service_account.lb.arn]
      type        = "AWS"
    }
    resources = [
      "${local.bucket_arn}/AWSLogs/${var.std_map.aws_account_id}/*"
    ]
    sid = "AllowElbLogging"
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
    var.allow_access_point ? [data.aws_iam_policy_document.ap_policy["this"].json] : [],
    var.allow_elb_logging ? [data.aws_iam_policy_document.elb_policy["this"].json] : [],
    local.has_custom_policy ? [jsonencode(module.this_policy["this"].iam_policy_doc)] : [],
  ]))
}

resource "aws_s3_bucket_policy" "this_bucket_policy" {
  for_each = var.policy_create ? { this = {} } : {}
  bucket   = var.bucket_name
  policy   = local.final_policy_json
}
