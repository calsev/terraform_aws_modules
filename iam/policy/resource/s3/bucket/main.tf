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
    actions = setsubtract(var.std_map.service_resource_access_action["s3"]["bucket"]["read_write"], [
      # These 3 actions are a security violation (condition may be fixable instead)
      "s3:PutBucketTagging",
      "s3:GetBucketTagging",
      "s3:GetBucketLocation",
    ])
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
    ]
    sid = "AccessPointBucketReadWrite"
  }
  statement {
    actions = var.std_map.service_resource_access_action["s3"]["object"]["read_write"]
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
      "${local.bucket_arn}/*"
    ]
    sid = "AccessPointObjectReadWrite"
  }
}

data "aws_elb_service_account" "lb" {}

data "aws_iam_policy_document" "elb_policy" {
  for_each = var.allow_service_logging ? { this = {} } : {}
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
  statement {
    actions = ["s3:GetBucketAcl"]
    condition {
      test     = "StringLike"
      values   = [local.cloud_trail_arn_prefix]
      variable = "AWS:SourceArn"
    }
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type        = "Service"
    }
    resources = [
      local.bucket_arn
    ]
    sid = "AllowCloudTrailLoggingBucket"
  }
  statement {
    actions = ["s3:PutObject"]
    condition {
      test     = "StringEquals"
      values   = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }
    condition {
      test     = "StringLike"
      values   = [local.cloud_trail_arn_prefix]
      variable = "AWS:SourceArn"
    }
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type        = "Service"
    }
    resources = [
      "${local.bucket_arn}/AWSLogs/${var.std_map.aws_account_id}/*"
    ]
    sid = "AllowCloudTrailLoggingObject"
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
    var.allow_service_logging ? [data.aws_iam_policy_document.elb_policy["this"].json] : [],
    local.has_custom_policy ? [jsonencode(module.this_policy["this"].iam_policy_doc)] : [],
  ]))
}

resource "aws_s3_bucket_policy" "this_bucket_policy" {
  for_each = var.policy_create ? { this = {} } : {}
  bucket   = var.bucket_name
  policy   = local.final_policy_json
}
