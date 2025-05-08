provider "aws" {
  region = local.std_var.aws_region_name
}

module "com_lib" {
  source  = "path/to/modules/common"
  std_var = local.std_var
}

module "lambda" {
  source                                 = "path/to/modules/lambda/function"
  ecr_data                               = data.terraform_remote_state.ecs.outputs.data["com"]
  function_ephemeral_storage_mib_default = 512
  function_map = {
    dir_create_local_archive_only = {
      dead_letter_queue_enabled           = false
      source_package_created_archive_path = "app_dir_no.zip" # Non-default archive path
      source_package_directory_local_path = "app"
    }
    dir_create_local_and_s3_archive = {
      environment_variable_map = {
        RUN_IT = 1
      }
      source_package_directory_local_path = "app"
      source_package_s3_bucket_name       = "example-deploy"
      vpc_key                             = "main"
    }
    # image = {
    #   source_image_command           = ["Hello beautiful world!"] # TODO
    #   source_image_entry_point       = ["echo"]
    #   source_image_repo_key          = "ubuntu"
    #   source_image_working_directory = "/"
    #   vpc_key                        = "main"
    # }
    local_existing_archive_no_s3 = {
      source_package_archive_local_path = "app.zip"
    }
    local_existing_archive_create_s3 = {
      source_package_archive_local_path = "app.zip"
      source_package_s3_bucket_name     = "example-deploy"
    }
    s3_existing_archive = {
      source_package_s3_bucket_name = "example-deploy"
      # Uses the archive created above for default path
      source_package_s3_object_key = "lambda_function/deployment_package_dir_create_local_and_s3_archive.zip"
    }
  }
  function_source_package_handler_default = "function.main"
  function_source_package_runtime_default = "python3.13"
  iam_data                                = data.terraform_remote_state.iam.outputs.data
  std_map                                 = module.com_lib.std_map
  vpc_data_map                            = data.terraform_remote_state.net.outputs.data.vpc_map
}

module "lambda_target" {
  source                               = "path/to/modules/lambda/alb_target"
  dns_data                             = data.terraform_remote_state.dns.outputs.data
  elb_data_map                         = data.terraform_remote_state.net.outputs.data.elb_map
  lambda_data_map                      = module.lambda.data
  listener_acm_certificate_key_default = "lambda.example.com"
  listener_action_order_default        = 24000
  listener_dns_from_zone_key_default   = "example.com"
  listener_elb_key_default             = "main"
  rule_condition_map_default = {
    host_match = {}
  }
  std_map = module.com_lib.std_map
  target_map = {
    example = {
      lambda_key = "dir_create_local_and_s3_archive"
    }
  }
  vpc_data_map    = data.terraform_remote_state.net.outputs.data.vpc_map
  vpc_key_default = "main"
}

module "local_config" {
  source  = "path/to/modules/local_config"
  content = local.output_data
  std_map = module.com_lib.std_map
}
