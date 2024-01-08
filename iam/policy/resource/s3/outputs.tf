output "iam_policy_doc" {
  value = jsondecode(local.policy_json)
}
