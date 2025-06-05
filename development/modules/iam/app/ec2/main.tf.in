data "aws_iam_policy_document" "ec2_modify_attribute_policy" {
  statement {
    actions = [
      "ec2:ModifyInstanceAttribute",
    ]
    resources = ["*"] # Must be ARN or *
  }
}

data "aws_iam_policy_document" "ec2_associate_eip_policy" {
  statement {
    actions = [
      "ec2:AssociateAddress",
    ]
    resources = ["*"] # Must be ARN or *
  }
}

module "policy" {
  source              = "../../../iam/policy/identity/base"
  {{ name.map_item() }}
  policy_map = {
    ec2_attribute_modify = {
      iam_policy_json = data.aws_iam_policy_document.ec2_modify_attribute_policy.json
    }
    ec2_eip_associate = {
      iam_policy_json = data.aws_iam_policy_document.ec2_associate_eip_policy.json
    }
  }
  std_map = var.std_map
}
