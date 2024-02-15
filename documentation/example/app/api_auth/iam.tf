module "api_role" {
  source   = "path/to/modules/iam/role/api_gateway"
  log_data = module.stage_log.data["prod"]
  name     = "api.example.com-api"
  policy_attach_arn_map = {
    auth_invoke        = module.lambda.data[local.lambda_name_auth].iam_policy_arn_map.write
    integration_invoke = module.lambda.data[local.lambda_name_integration].iam_policy_arn_map.write
    options_invoke     = module.lambda.data[local.lambda_name_options].iam_policy_arn_map.write
  }
  std_map = module.com_lib.std_map
}
