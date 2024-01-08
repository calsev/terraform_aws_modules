output "iam_policy_arn" {
  value = var.name != null ? aws_iam_policy.policy["this"].arn : null
}
