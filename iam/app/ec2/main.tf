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
  source                          = "../../../iam/policy/identity/base"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
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

module "efs_policy" {
  source                          = "../../../iam/policy/identity/efs"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  policy_map                      = local.efs_policy_map
  std_map                         = var.std_map
}

module "efs_role" {
  source                          = "../../../iam/role/ec2/instance"
  monitor_data                    = var.monitor_data
  name                            = "efs_mount"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  role_policy_attach_arn_map_default = {
    efs_read_write = module.efs_policy.data["mount"].policy_map["read_write"].iam_policy_arn
  }
  std_map = var.std_map
}
