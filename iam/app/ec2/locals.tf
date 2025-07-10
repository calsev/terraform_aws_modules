locals {
  efs_policy_map = {
    mount = { # This gets appended with efs
      efs_arn = "*"
    }
  }
  output_data = {
    iam_policy_arn_ec2_associate_eip    = module.policy.data["ec2_eip_associate"].iam_policy_arn
    iam_policy_doc_ec2_associate_eip    = module.policy.data["ec2_eip_associate"].iam_policy_doc
    iam_policy_arn_ec2_modify_attribute = module.policy.data["ec2_attribute_modify"].iam_policy_arn
    iam_policy_doc_ec2_modify_attribute = module.policy.data["ec2_attribute_modify"].iam_policy_doc
    iam_policy_mount_efs                = module.efs_policy.data["mount"]
    iam_role_mount_efs                  = module.efs_role.data
  }
}
