provider "aws" {
  region = local.std_var.aws_region_name
}

module "com_lib" {
  source  = "path/to/modules/common"
  std_var = local.std_var
}

module "ecr_repo_mirror" {
  source          = "path/to/modules/app/ecr_repo_mirror"
  iam_data        = data.terraform_remote_state.iam.outputs.data
  monitor_data    = data.terraform_remote_state.monitor.outputs.data
  std_map         = module.com_lib.std_map
  vpc_data_map    = data.terraform_remote_state.net.outputs.data.vpc_map
  vpc_key_default = "main"
}

module "local_config" {
  source  = "path/to/modules/local_config"
  content = local.output_data
  std_map = module.com_lib.std_map
}
