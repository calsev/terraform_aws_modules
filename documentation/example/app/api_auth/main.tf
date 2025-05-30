provider "aws" {
  region = local.aws_region_name
}

module "com_lib" {
  source   = "path/to/modules/common"
  for_each = local.std_var_map
  std_var  = each.value
}

module "lambda" {
  source   = "path/to/modules/lambda/function"
  for_each = local.env_list
  function_map = {
    (local.lambda_name_auth) = {
      source_package_handler = "auth.main"
    }
    (local.lambda_name_integration) = {
      source_package_handler = "post.main"
    }
    (local.lambda_name_options) = {
      source_package_handler = "options.main"
    }
    (local.lambda_name_trigger) = {
      source_package_handler = "trigger.main"
    }
  }
  function_ephemeral_storage_mib_default               = 512
  function_dead_letter_queue_enabled_default           = false
  function_source_package_directory_local_path_default = "app/src"
  function_source_package_runtime_default              = "python3.13"
  iam_data                                             = data.terraform_remote_state.iam.outputs.data
  std_map                                              = module.com_lib[each.key].std_map
}

module "api" {
  source   = "path/to/modules/api_gateway/stack"
  for_each = local.env_list
  api_auth_map_default = {
    (local.auth_key_cognito) = {
      cognito_client_app_key = "app"
      cognito_pool_key       = "app"
    }
    (local.auth_key_lambda) = {
      lambda_key = local.lambda_name_auth
    }
  }
  api_map = {
    (local.api_name) = {
      auth_request_iam_role_arn_default = module.api_role[each.key].data.iam_role_arn
      integration_iam_role_arn_default  = module.api_role[each.key].data.iam_role_arn
      integration_map = {
        lambda = {
          route_map = {
            "POST /anon" = {
            }
            "POST /auth-cognito" = {
              auth_key = local.auth_key_cognito
            }
            "POST /auth-lambda" = {
              auth_key = local.auth_key_lambda
            }
          }
          target_uri = module.lambda[each.key].data[local.lambda_name_integration].invoke_arn
        }
        options = {
          route_map = {
            "OPTIONS /{path+}" = {
            }
          }
          target_uri = module.lambda[each.key].data[local.lambda_name_options].invoke_arn
        }
      }
      integration_service_default = "lambda"
      name_infix                  = false
      stage_map = {
        "$default" = {}
      }
    }
  }
  cognito_data_map = data.terraform_remote_state.core.outputs.data[each.key].user_pool
  dns_data         = data.terraform_remote_state.dns.outputs.data
  domain_map = {
    (local.api_name) = {}
  }
  domain_dns_from_zone_key_default = "example.com"
  lambda_data_map                  = module.lambda[each.key].data
  std_map                          = module.com_lib[each.key].std_map
}

module "local_config" {
  source   = "path/to/modules/local_config"
  for_each = local.env_list
  content  = local.output_data_map[each.key]
  std_map  = module.com_lib[each.key].std_map
}
