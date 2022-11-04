output "data" {
  value = merge(module.this_policy.data, {
    log_group_arn  = aws_cloudwatch_log_group.this_log_group.arn
    log_group_name = aws_cloudwatch_log_group.this_log_group.name
  })
}
