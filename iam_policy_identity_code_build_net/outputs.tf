output "data" {
  value = {
    iam_policy_arn  = module.this_policy.iam_policy_arn
    iam_policy_json = data.aws_iam_policy_document.network_policy.json
  }
}
