output "iam_policy_doc_assume_role" {
  value = jsondecode(data.aws_iam_policy_document.assume_role_policy.json)
}
