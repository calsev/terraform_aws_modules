locals {
  function_arn = startswith(var.function_name, "arn:") ? var.function_name : "arn:${var.std_map.iam_partition}:lambda:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:function:${var.function_name}"
}
