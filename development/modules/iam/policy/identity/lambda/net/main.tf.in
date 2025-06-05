data "aws_iam_policy_document" "network_policy" {
  # EC2 service is infeasible for using access-resource
  statement {
    actions = [
      "ec2:DescribeNetworkInterfaces",
    ]
    resources = ["*"]
    sid       = "StarRead"
  }
  statement {
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
    ]
    resources = ["*"]
    sid       = "StarWrite"
  }
}

{{ iam.policy_identity_base() }}
