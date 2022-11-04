output "iam_policy_arn" {
  value = module.this_policy.iam_policy_arn
}

output "iam_policy_json" {
  value = data.aws_iam_policy_document.this_policy_doc.json
}
