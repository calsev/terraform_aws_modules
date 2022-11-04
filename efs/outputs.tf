output "efs_arn" {
  value = aws_efs_file_system.this_fs.arn
}

output "efs_dns_name" {
  value = aws_efs_file_system.this_fs.dns_name
}

output "efs_id" {
  value = aws_efs_file_system.this_fs.id
}

output "iam_policy_arn_efs_read" {
  value = var.create_policies ? aws_iam_policy.iam_policy_efs_read["this"].arn : null
}

output "iam_policy_arn_efs_write" {
  value = var.create_policies ? aws_iam_policy.iam_policy_efs_write["this"].arn : null
}

output "iam_policy_json_efs_read" {
  value = data.aws_iam_policy_document.efs_read.json
}

output "iam_policy_json_efs_write" {
  value = data.aws_iam_policy_document.efs_write.json
}
