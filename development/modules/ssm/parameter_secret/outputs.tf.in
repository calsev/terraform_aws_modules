output "data" {
  value = local.output_data
}

output "secret_map" {
  value = module.initial_value.secret_map
}

output "ready_arn_map" {
  # Unknown until the parameter exists, so a reader waits on only its own parameter
  value = {
    for k, _ in local.lx_map : k => aws_ssm_parameter.this_param[k].arn
  }
}
