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

data "aws_iam_policy_document" "transport_policy" {
  for_each = var.allow_insecure_access ? {} : { this = {} }
  statement {
    actions = ["s3:*"]
    condition {
      test     = "Bool"
      values   = ["false"]
      variable = "aws:SecureTransport"
    }
    effect = "Deny"
    principals {
      identifiers = ["*"]
      type        = "*"
    }
    resources = [
      local.bucket_arn,
      "${local.bucket_arn}/*",
    ]
    sid = "DenyInsecureAccess"
  }
}

data "aws_iam_policy_document" "config_policy" {
  for_each = var.allow_config_recording ? { this = {} } : {}
  statement {
    actions = ["s3:ListBucket"]
    condition {
      test     = "StringEquals"
      values   = [var.std_map.aws_account_id]
      variable = "AWS:SourceAccount"
    }
    principals {
      identifiers = ["config.amazonaws.com"]
      type        = "Service"
    }
    resources = [local.bucket_arn]
    sid       = "AllowConfigBucketExistenceCheck"
  }
  statement {
    actions = ["s3:GetBucketAcl"]
    condition {
      test     = "StringEquals"
      values   = [var.std_map.aws_account_id]
      variable = "AWS:SourceAccount"
    }
    principals {
      identifiers = ["config.amazonaws.com"]
      type        = "Service"
    }
    resources = [local.bucket_arn]
    sid       = "AllowConfigBucketPermissionCheck"
  }
  statement {
    actions = ["s3:PutObject"]
    condition {
      test     = "StringEquals"
      values   = [var.std_map.aws_account_id]
      variable = "AWS:SourceAccount"
    }
    condition {
      test     = "StringEquals"
      values   = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }
    principals {
      identifiers = ["config.amazonaws.com"]
      type        = "Service"
    }
    resources = [local.log_object_prefix]
    sid       = "AllowConfigBucketDelivery"
  }
}

data "aws_elb_service_account" "lb" {}

data "aws_iam_policy_document" "trail_policy" {
  for_each = var.allow_log_cloudtrail ? { this = {} } : {}
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

data "aws_iam_policy_document" "alb_policy" {
  for_each = var.allow_log_elb ? { this = {} } : {}
  # See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/enable-access-logging.html#attach-bucket-policy
  statement {
    actions = ["s3:PutObject"]
    principals {
      identifiers = [data.aws_elb_service_account.lb.arn]
      type        = "AWS"
    }
    resources = [
      local.log_object_prefix
    ]
    sid = "AllowAlbLogging"
  }
}

data "aws_iam_policy_document" "log_delivery_policy" {
  for_each = local.allow_log_delivery ? { this = {} } : {}
  # See https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-access-logs.html#access-logging-bucket-requirements
  # https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs-s3-permissions.html
  # See https://docs.aws.amazon.com/waf/latest/developerguide/logging-s3.html
  statement {
    actions = ["s3:GetBucketAcl"]
    condition {
      test     = "ArnLike"
      values   = [local.logs_arn_prefix]
      variable = "AWS:SourceArn"
    }
    condition {
      test     = "StringEquals"
      values   = [var.std_map.aws_account_id]
      variable = "AWS:SourceAccount"
    }
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
    resources = [
      local.bucket_arn
    ]
    sid = "AllowLogDeliveryAclCheck"
  }
  statement {
    actions = ["s3:PutObject"]
    condition {
      test     = "ArnLike"
      values   = [local.logs_arn_prefix]
      variable = "AWS:SourceArn"
    }
    condition {
      test     = "StringEquals"
      values   = [var.std_map.aws_account_id]
      variable = "AWS:SourceAccount"
    }
    condition {
      test     = "StringEquals"
      values   = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
    resources = [
      local.log_object_prefix
    ]
    sid = "AllowLogDeliveryWrite"
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
    var.allow_config_recording ? [data.aws_iam_policy_document.config_policy["this"].json] : [],
    var.allow_insecure_access ? [] : [data.aws_iam_policy_document.transport_policy["this"].json],
    var.allow_log_cloudtrail ? [data.aws_iam_policy_document.trail_policy["this"].json] : [],
    var.allow_log_elb ? [data.aws_iam_policy_document.alb_policy["this"].json] : [],
    local.allow_log_delivery ? [data.aws_iam_policy_document.log_delivery_policy["this"].json] : [],
    local.has_custom_policy ? [jsonencode(module.this_policy["this"].iam_policy_doc)] : [],
  ]))
}

resource "aws_s3_bucket_policy" "this_bucket_policy" {
  for_each = var.policy_create ? { this = {} } : {}
  bucket   = var.bucket_name
  policy   = local.final_policy_json
}
