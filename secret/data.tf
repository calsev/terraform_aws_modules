data "aws_ssm_parameter" "token_param" {
  for_each        = var.ssm_param_name == null ? {} : { this = {} }
  name            = var.ssm_param_name
  with_decryption = true
}

data "aws_secretsmanager_secret" "token_secret" {
  for_each = var.sm_secret_arn == null ? {} : { this = {} }
  arn      = var.sm_secret_arn
}

data "aws_secretsmanager_secret_version" "token_version" {
  for_each  = var.sm_secret_arn == null ? {} : { this = {} }
  secret_id = data.aws_secretsmanager_secret.token_secret[each.key].id
}
