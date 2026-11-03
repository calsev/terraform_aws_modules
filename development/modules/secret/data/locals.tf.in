locals {
  secret_string = var.secret_is_param ? data.aws_ssm_parameter.this_param["this"].value : data.aws_secretsmanager_secret_version.this_secret_version["this"].secret_string
  secret_value  = var.secret_key == null ? local.secret_string : jsondecode(local.secret_string)[var.secret_key]
}
