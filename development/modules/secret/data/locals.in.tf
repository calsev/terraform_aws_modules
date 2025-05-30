locals {
  # tflint-ignore: terraform_unused_declarations
  mutual_exclusion_secret = var.ssm_param_name == null && var.sm_secret_name != null || var.ssm_param_name != null && var.sm_secret_name == null ? null : file("ERROR: Exactly one secret is required")
  secret_string           = var.ssm_param_name == null ? data.aws_secretsmanager_secret_version.this_secret_version["this"].secret_string : data.aws_ssm_parameter.this_param["this"].value
  secret_value            = var.secret_key == null ? local.secret_string : jsondecode(local.secret_string)[var.secret_key]
}
