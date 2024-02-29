data "aws_iam_policy_document" "ec2_associate_eip_policy" {
  statement {
    actions = [
      "ec2:AssociateAddress",
    ]
    resources = ["*"] # Must be ARN or *
  }
}

module "ec2_associate_eip_policy" {
  source          = "../../../iam/policy/identity/base"
  iam_policy_json = data.aws_iam_policy_document.ec2_associate_eip_policy.json
  name            = "ec2_eip_associate"
  name_prefix     = var.name_prefix
  std_map         = var.std_map
}

data "aws_iam_policy_document" "ec2_modify_attribute_policy" {
  statement {
    actions = [
      "ec2:ModifyInstanceAttribute",
    ]
    resources = ["*"] # Must be ARN or *
  }
}

module "ec2_modify_attribute_policy" {
  source          = "../../../iam/policy/identity/base"
  iam_policy_json = data.aws_iam_policy_document.ec2_modify_attribute_policy.json
  name            = "ec2_attribute_modify"
  name_prefix     = var.name_prefix
  std_map         = var.std_map
}
