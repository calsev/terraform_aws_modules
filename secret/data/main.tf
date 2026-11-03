data "aws_ssm_parameter" "this_param" {
  for_each        = var.secret_is_param ? { this = {} } : {}
  name            = var.secret_id
  with_decryption = true
}

data "aws_secretsmanager_secret_version" "this_secret_version" {
  for_each  = var.secret_is_param ? {} : { this = {} }
  secret_id = var.secret_id
}
