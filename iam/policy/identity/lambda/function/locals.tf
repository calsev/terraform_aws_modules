locals {
  function_name_list = concat(var.function_name_list, var.function_name == null ? [] : [var.function_name])
  function_arn_list = [
    for function_name in local.function_name_list : startswith(function_name, "arn:") ? function_name : "arn:${var.std_map.iam_partition}:lambda:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:function:${function_name}"
  ]
}
