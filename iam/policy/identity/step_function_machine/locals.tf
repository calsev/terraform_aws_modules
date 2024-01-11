locals {
  machine_arn = "arn:${var.std_map.iam_partition}:states:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:stateMachine:${var.machine_name}"
}
