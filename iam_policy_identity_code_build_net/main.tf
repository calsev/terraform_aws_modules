data "aws_iam_policy_document" "network_policy" {
  statement {
    actions = [
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
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
  statement {
    actions = [
      "ec2:CreateNetworkInterfacePermission",
    ]
    resources = ["arn:${var.std_map.iam_partition}:ec2:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:network-interface/*"]
    sid       = "InterfaceWrite"
  }
}

module "this_policy" {
  source          = "../iam_policy_identity"
  iam_policy_json = data.aws_iam_policy_document.network_policy.json
  name            = var.name
  name_infix      = var.name_infix
  name_prefix     = var.name_prefix
  std_map         = var.std_map
}
