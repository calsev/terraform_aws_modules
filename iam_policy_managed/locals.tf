locals {
  output_data = {
    for k, v in var.policy_map : "iam_policy_arn_${k}" => "arn:${var.std_map.iam_partition}:iam::aws:policy/${v}"
  }
}
