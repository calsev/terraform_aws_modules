output "data" {
  value = {
    iam_policy_arn = module.this_policy.iam_policy_arn
    iam_policy_doc = jsondecode(data.aws_iam_policy_document.this_policy_doc.json)
  }
}
