locals {
  api_name                = "auth-api.example.com"
  auth_key_cognito        = "cognito"
  auth_key_lambda         = "lambda"
  client_app_name         = "gen_pop"
  lambda_name_auth        = "auth"
  lambda_name_integration = "integration"
  output_data = {
    api    = module.api.data
    lambda = module.lambda.data
    log    = module.stage_log.data
    pool   = module.user_pool.data
    role   = module.api_role.data
  }
  pool_name = "app"
  stage_map = {
    prod = {}
  }
  std_var = {
    app             = "app-auth"
    aws_region_name = "us-west-2"
    env             = "com"
  }
}
