output "iam_policy_doc" {
  value = jsondecode(local.final_policy_json)
}
