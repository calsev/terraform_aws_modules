module "lambda" {
  source                                  = "../../lambda/function"
  function_ephemeral_storage_mib_default  = 512
  function_map                            = local.create_lambda_map
  function_source_package_handler_default = "rotation.lambda_handler"
  function_source_package_runtime_default = "python3.13"
  iam_data                                = var.iam_data
  monitor_data                            = var.monitor_data
  std_map                                 = var.std_map
  vpc_az_key_list_default                 = var.vpc_az_key_list_default
  vpc_data_map                            = var.vpc_data_map
  vpc_key_default                         = var.vpc_key_default
  vpc_security_group_key_list_default     = var.vpc_security_group_key_list_default
  vpc_segment_key_default                 = var.vpc_segment_key_default
}

module "lambda_permission" {
  source                       = "../../lambda/permission"
  name_prepend_default         = "secret_rotation"
  permission_map               = local.create_lambda_permission_map
  permission_principal_default = "secretsmanager.amazonaws.com"
  std_map                      = var.std_map
}

resource "aws_secretsmanager_secret_rotation" "this_rotation" {
  for_each            = local.create_rotation_map
  rotate_immediately  = each.value.rotate_immediately
  rotation_lambda_arn = each.value.lambda_arn
  rotation_rules {
    automatically_after_days = each.value.rotation_schedule_days
    duration                 = each.value.rotation_schedule_window
    schedule_expression      = each.value.rotation_schedule_expression
  }
  secret_id = each.value.secret_id
}
