locals {
  api_map = {
    (local.api_name) = {
      integration_iam_role_arn_default = module.api_role.data.iam_role_arn
      integration_map = {
        lambda = {
          route_map = {
            "POST /lambda" = {
            }
          }
          service    = "lambda"
          target_uri = module.lambda.data[local.lambda_name].invoke_arn
        }
        sqs = {
          route_map = {
            "POST /sqs" = {
            }
          }
          service    = "sqs"
          target_uri = module.sqs.data[local.queue_name].url
        }
        states = {
          route_map = {
            "POST /states" = {
            }
          }
          service    = "states"
          target_arn = module.step_function.data[local.machine_name].arn
        }
        train = {
          route_map = {
            "POST /train" = {
              authorization_type = "AWS_IAM"
            }
          }
          service    = "states"
          target_arn = module.step_function.data[local.machine_name].arn
        }
      }
      name_infix = false
      stage_map = {
        for k, v in local.stage_map : k => merge(v, {
          log_group_arn = module.stage_log.data[k].log_group_arn
        })
      }
    }
  }
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
    prod = {
    }
  }
  std_var = {
    app             = "app-api"
    aws_region_name = "us-west-2"
    env             = "prod"
  }
}
