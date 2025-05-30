data "aws_iam_policy_document" "cloudtrail_policy" {
  for_each = var.allow_cloudtrail ? { this = {} } : {}
  statement {
    actions = [
      "kms:DescribeKey",
      "kms:GenerateDataKey"
    ]
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type        = "Service"
    }
    resources = ["*"]
    sid       = "EnableCloudtrailPermissions"
  }
}

data "aws_iam_policy_document" "iam_delegation_policy" {
  for_each = var.allow_iam_delegation ? { this = {} } : {}
  statement {
    actions = ["kms:*"]
    principals {
      identifiers = ["arn:${var.std_map.iam_partition}:iam::${var.std_map.aws_account_id}:root"]
      type        = "AWS"
    }
    resources = ["*"]
    sid       = "EnableIamUserPermissions"
  }
}

data "aws_iam_policy_document" "final_policy" {
  source_policy_documents = concat(
    var.allow_cloudtrail ? [data.aws_iam_policy_document.cloudtrail_policy["this"].json] : [],
    var.allow_iam_delegation ? [data.aws_iam_policy_document.iam_delegation_policy["this"].json] : [],
  )
}

resource "aws_kms_key_policy" "this_policy" {
  for_each = var.policy_create ? { this = {} } : {}
  key_id   = var.key_id
  policy   = local.final_policy_json
}
