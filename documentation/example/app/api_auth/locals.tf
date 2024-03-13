locals {
  api_name                = "auth_api.example.com"
  auth_key_cognito        = "cognito"
  auth_key_lambda         = "lambda"
  client_app_name         = "gen_pop"
  lambda_name_auth        = "auth"
  lambda_name_integration = "integration"
  lambda_name_options     = "options"
  lambda_name_trigger     = "trigger"
  output_data = {
    api    = module.api.data
    lambda = module.lambda.data
    pool   = module.user_pool.data
    role   = module.api_role.data
  }
  pool_name = "app"
  stage_map = {
    prd = {}
  }
  std_var = {
    app             = "app-auth"
    aws_region_name = "us-west-2"
    env             = "com"
  }
}
