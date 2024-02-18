output "secret" {
  value = var.ssm_param_name != null ? data.aws_ssm_parameter.token_param["this"].value : jsondecode(data.aws_secretsmanager_secret_version.token_version["this"].secret_string)[var.sm_secret_key]
}
