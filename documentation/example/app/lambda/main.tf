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
      dead_letter_queue_enabled             = false
      source_package_directory_archive_path = "app_dir_no.zip" # Non-default archive path
      source_package_directory_local_path   = "app"
    }
    dir_create_local_and_s3_archive = {
      architecture_list = ["arm64"]
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
  function_source_package_runtime_default = "python3.11"
  iam_data                                = data.terraform_remote_state.iam.outputs.data
  std_map                                 = module.com_lib.std_map
  vpc_data_map                            = data.terraform_remote_state.net.outputs.data.vpc_map
}

module "local_config" {
  source  = "path/to/modules/local_config"
  content = local.output_data
  std_map = module.com_lib.std_map
}
