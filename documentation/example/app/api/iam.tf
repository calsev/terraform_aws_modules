module "machine_role" {
  source   = "path/to/modules/iam/role/step_function"
  log_data = module.stage_log.data["prod"]
  name     = "pipeline-states"
  std_map  = module.com_lib.std_map
}

module "api_role" {
  source   = "path/to/modules/iam/role/api_gateway"
  log_data = module.stage_log.data["prod"]
  name     = "api.example.com-api"
  policy_attach_arn_map = {
    lambda_invoke = module.lambda.data[local.lambda_name].iam_policy_arn_map.write
    machine_start = module.step_function.data[local.machine_name].iam_policy_arn_map.write
    queue_push    = module.sqs.data[local.queue_name].iam_policy_arn_map.write
  }
  std_map = module.com_lib.std_map
}
