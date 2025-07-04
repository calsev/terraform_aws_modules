module "lambda" {
  source                                  = "../../lambda/function"
  function_ephemeral_storage_mib_default  = 512
  function_map                            = local.create_lambda_map
  function_source_package_handler_default = "purchase_reserved_instance.lambda_handler"
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
  permission_map               = local.create_lambda_permission_map
  permission_principal_default = "events.amazonaws.com"
  std_map                      = var.std_map
}

module "trigger" {
  source                              = "../../event/trigger/base"
  event_map                           = local.create_trigger_map
  event_schedule_expression_default   = var.event_schedule_expression_default
  event_target_service_default        = "lambda"
  iam_data                            = var.iam_data
  monitor_data                        = var.monitor_data
  std_map                             = var.std_map
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_data_map                        = var.vpc_data_map
  vpc_key_default                     = var.vpc_key_default
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
  vpc_segment_key_default             = var.vpc_segment_key_default
}
