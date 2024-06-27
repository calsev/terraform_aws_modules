provider "aws" {
  region = local.std_var.aws_region_name
}

module "com_lib" {
  source  = "path/to/modules/common"
  std_var = local.std_var
}

module "ci_cd_aws" {
  source                                = "path/to/modules/ci_cd/aws_account"
  bucket_log_target_bucket_name_default = "example-log"
  log_public_enabled                    = true
  server_type_to_secret = {
    GITHUB = {
      ssm_param_name = "github_com_example_access_token"
    }
  }
  std_map = module.com_lib.std_map
}

module "ci_cd" {
  source = "path/to/modules/ci_cd/remote/account"
  connection_map = {
    "github_example" : {},
  }
  std_map = module.com_lib.std_map
}

module "local_config" {
  source  = "path/to/modules/local_config"
  content = local.output_data
  std_map = module.com_lib.std_map
}
