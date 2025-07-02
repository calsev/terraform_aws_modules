data "aws_iam_policy_document" "purchaser_policy" {
  statement {
    actions = [
      "logs:DescribeLogGroups",
      "logs:PutRetentionPolicy",
    ]
    resources = ["*"]
    sid       = "LogsUpdateRetention"
  }
}

module "retainer_policy" {
  source = "../../iam/policy/identity/base"
  policy_map = {
    (local.policy_key) = {
      iam_policy_json = data.aws_iam_policy_document.purchaser_policy.json
    }
  }
  std_map = var.std_map
}
