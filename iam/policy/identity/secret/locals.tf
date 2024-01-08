locals {
  # tflint-ignore: terraform_unused_declarations
  mutual_exclusion_secret = var.ssm_param_name == null && var.sm_secret_name != null || var.ssm_param_name != null && var.sm_secret_name == null ? null : file("ERROR: Exactly one secret is required")
  resource_map = var.ssm_param_name == null ? {
    secret = ["arn:${var.std_map.iam_partition}:${local.service_name}:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:secret:${var.sm_secret_name == null ? "" : var.sm_secret_name}*"]
    star   = ["*"]
    } : {
    parameter = ["arn:${var.std_map.iam_partition}:${local.service_name}:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:parameter/${var.ssm_param_name}"]
    star      = ["*"]
  }
  service_name = var.ssm_param_name == null ? "secretsmanager" : "ssm"
}
