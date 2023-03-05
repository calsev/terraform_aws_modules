output "data" {
  value = {
    iam_policy_arn_map = var.name == null ? null : { for k, _ in local.sid_map : k => module.this_policy[k].iam_policy_arn }
    iam_policy_doc_map = { for k, _ in local.sid_map : k => jsondecode(data.aws_iam_policy_document.this_policy_doc[k].json) }
  }
}
