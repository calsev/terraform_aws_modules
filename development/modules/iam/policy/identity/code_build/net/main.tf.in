data "aws_iam_policy_document" "network_policy" {
  # EC2 service is infeasible for using access-resource
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
    condition {
      test     = "StringLike"
      values   = ["arn:${var.std_map.iam_partition}:ec2:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:subnet/*"]
      variable = "ec2:Subnet"
    }
    condition {
      test     = "StringEquals"
      values   = ["codebuild.amazonaws.com"]
      variable = "ec2:AuthorizedService"
    }
    resources = ["arn:${var.std_map.iam_partition}:ec2:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:network-interface/*"]
    sid       = "InterfaceWrite"
  }
}

{{ iam.policy_identity_base() }}
