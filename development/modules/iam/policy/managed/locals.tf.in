locals {
  policy_arn_map = {
    for k, v in var.policy_map : k => "arn:${var.std_map.iam_partition}:iam::aws:policy/${v}"
  }
  policy_doc_map = {
    for k, v in var.policy_map : "iam_policy_doc_${k}" => jsondecode(data.aws_iam_policy.this_policy[k].policy)
  }
  policy_map = {
    for k, v in var.policy_map : "iam_policy_arn_${k}" => local.policy_arn_map[k]
  }
  output_data = merge(
    local.policy_doc_map,
    local.policy_map,
  )
}
