locals {
  api_name     = "api.example.com"
  lambda_name  = "func"
  machine_name = "pipeline"
  output_data = {
    api    = module.api.data
    lambda = module.lambda.data
    log    = module.stage_log.data
    queue  = module.sqs.data
    role = {
      api     = module.api_role.data
      machine = module.machine_role.data
    }
    step_function = module.step_function.data
  }
  queue_name = "async_request"
  stage_map = {
    dev = {
    }
    prd = {
    }
  }
  std_var = {
    app             = "app-api"
    aws_region_name = "us-west-2"
    env             = "com"
  }
}
