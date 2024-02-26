provider "aws" {
  region = local.std_var.aws_region_name
}

module "com_lib" {
  source  = "path/to/modules/common"
  std_var = local.std_var
}

module "stage_log" {
  source  = "path/to/modules/cw/log_group"
  log_map = local.stage_map
  std_map = module.com_lib.std_map
}

module "sqs" {
  source = "path/to/modules/sqs/queue"
  queue_map = {
    (local.queue_name) = {}
  }
  std_map = module.com_lib.std_map
}

module "step_function" {
  source = "path/to/modules/step_function"
  machine_map = {
    (local.machine_name) = {
      definition_json = templatefile("${path.module}/pipeline_machine.json", {
      })
      log_data = module.stage_log.data["prod"]
    }
  }
  machine_iam_role_arn_default = module.machine_role.data.iam_role_arn
  std_map                      = module.com_lib.std_map
}

module "lambda" {
  source = "path/to/modules/lambda/function"
  function_map = {
    (local.lambda_name) = {}
  }
  function_architecture_list_default                   = ["arm64"]
  function_ephemeral_storage_mib_default               = 512
  function_dead_letter_queue_enabled_default           = false
  function_source_package_directory_local_path_default = "app"
  function_source_package_handler_default              = "function.main"
  function_source_package_runtime_default              = "python3.11"
  iam_data                                             = data.terraform_remote_state.iam.outputs.data
  std_map                                              = module.com_lib.std_map
  vpc_data_map                                         = data.terraform_remote_state.net.outputs.data.vpc_map
  vpc_key_default                                      = "main"
}

module "api" {
  source   = "path/to/modules/api_gateway/stack"
  api_map  = local.api_map
  dns_data = data.terraform_remote_state.dns.outputs.data
  domain_map = {
    (local.api_name) = {}
  }
  domain_dns_from_zone_key_default = "example.com"
  std_map                          = module.com_lib.std_map
}

module "local_config" {
  source  = "path/to/modules/local_config"
  content = local.output_data
  std_map = module.com_lib.std_map
}
