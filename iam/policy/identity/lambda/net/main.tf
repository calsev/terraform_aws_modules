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

module "this_policy" {
  source          = "../../../../../iam/policy/identity/base"
  iam_policy_json = data.aws_iam_policy_document.network_policy.json
  name            = var.name
  name_infix      = var.name_infix
  name_prefix     = var.name_prefix
  std_map         = var.std_map
}
