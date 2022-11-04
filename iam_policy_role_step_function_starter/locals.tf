locals {
  machine_name = var.step_function_name_infix ? "${var.std_map.resource_name_prefix}${var.step_function_name}${var.std_map.resource_name_suffix}" : var.step_function_name
  machine_arn  = "arn:${var.std_map.iam_partition}:states:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:stateMachine:${local.machine_name}"
}
