locals {
  api_name                = "auth_api.example.com"
  auth_key_cognito        = "cognito"
  auth_key_lambda         = "lambda"
  aws_region_name         = "us-west-2"
  env_list                = toset(["prd"])
  lambda_name_auth        = "auth"
  lambda_name_integration = "integration"
  lambda_name_options     = "options"
  lambda_name_trigger     = "trigger"
  output_data_map = {
    for env in local.env_list : env => {
      api    = module.api[env].data
      lambda = module.lambda[env].data
      role   = module.api_role[env].data
    }
  }
  std_var_map = {
    for env in local.env_list : env => {
      app             = "app-auth"
      aws_region_name = local.aws_region_name
      env             = env
    }
  }
}
