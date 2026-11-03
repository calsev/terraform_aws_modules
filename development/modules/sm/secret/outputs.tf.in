output "data" {
  value = local.output_data
}

output "secret_map" {
  value = module.initial_value.secret_map
}

output "ready_arn_map" {
  # Unknown until the secret has its initial value, so a reader waits on only its own secret
  value = {
    for k, _ in local.lx_map : k => contains(keys(aws_secretsmanager_secret_version.initial_value), k) ? aws_secretsmanager_secret_version.initial_value[k].secret_arn : aws_secretsmanager_secret.this_secret[k].arn
  }
}
