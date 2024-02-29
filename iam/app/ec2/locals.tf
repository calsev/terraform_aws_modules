locals {
  output_data = {
    iam_policy_arn_ec2_associate_eip    = module.ec2_associate_eip_policy.iam_policy_arn
    iam_policy_doc_ec2_associate_eip    = jsondecode(data.aws_iam_policy_document.ec2_associate_eip_policy.json)
    iam_policy_arn_ec2_modify_attribute = module.ec2_modify_attribute_policy.iam_policy_arn
    iam_policy_doc_ec2_modify_attribute = jsondecode(data.aws_iam_policy_document.ec2_modify_attribute_policy.json)
  }
}
