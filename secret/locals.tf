locals {
  # tflint-ignore: terraform_unused_declarations
  mutual_exclusion_secret = var.ssm_param_name == null && var.sm_secret_arn != null && var.sm_secret_key != null || var.ssm_param_name != null && var.sm_secret_arn == null ? null : file("ERROR: Exactly one secret is required")
}
