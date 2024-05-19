locals {
  api_name                = "auth_api.example.com"
  auth_key_cognito        = "cognito"
  auth_key_lambda         = "lambda"
  lambda_name_auth        = "auth"
  lambda_name_integration = "integration"
  lambda_name_options     = "options"
  lambda_name_trigger     = "trigger"
  output_data = {
    api    = module.api.data
    lambda = module.lambda.data
    role   = module.api_role.data
  }
  std_var = {
    app             = "app-auth"
    aws_region_name = "us-west-2"
    env             = "com"
  }
}
