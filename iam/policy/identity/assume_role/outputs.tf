output "data" {
  value = {
    iam_policy_arn = module.policy.iam_policy_arn
    iam_policy_doc = jsondecode(data.aws_iam_policy_document.assume_role.json)
  }
}
