data "aws_ssm_parameter" "this_param" {
  for_each        = var.ssm_param_name == null ? {} : { this = {} }
  name            = var.ssm_param_name
  with_decryption = true
}

data "aws_secretsmanager_secret" "this_secret" {
  for_each = var.sm_secret_name == null ? {} : { this = {} }
  arn      = "arn:${var.std_map.iam_partition}:secretsmanager:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:secret:${var.sm_secret_name}"
}

data "aws_secretsmanager_secret_version" "this_secret_version" {
  for_each  = var.sm_secret_name == null ? {} : { this = {} }
  secret_id = data.aws_secretsmanager_secret.this_secret[each.key].id
}
