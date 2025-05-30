data "aws_iam_policy_document" "purchaser_policy" {
  statement {
    actions = [
      "ec2:DescribeReservedInstances",
      "ec2:DescribeReservedInstancesOfferings",
      "ec2:PurchaseReservedInstancesOffering",
    ]
    resources = ["*"]
    sid       = "EC2ReservedInstancesAccess"
  }
  statement {
    actions = [
      "servicequotas:GetServiceQuota",
      "servicequotas:ListServiceQuotas",
    ]
    resources = ["*"]
    sid       = "ServiceQuotasReadAccess"
  }
  statement {
    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail",
    ]
    resources = ["*"]
    sid       = "SESSendEmail"
  }
  statement {
    actions = [
      "cloudwatch:PutMetricData",
    ]
    resources = ["*"]
    sid       = "CloudWatchPutMetric"
  }
}

module "purchaser_policy" {
  source = "../../iam/policy/identity/base"
  policy_map = {
    (local.policy_key) = {
      iam_policy_json = data.aws_iam_policy_document.purchaser_policy.json
    }
  }
  std_map = var.std_map
}
