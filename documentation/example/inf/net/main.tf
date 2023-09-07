provider "aws" {
  region = local.std_var.aws_region_name
}

module "com_lib" {
  source  = "path/to/modules/common"
  std_var = local.std_var
}

module "vpc_stack" {
  source                   = "path/to/modules/vpc_stack"
  std_map                  = module.com_lib.std_map
  vpc_map                  = local.vpc_map
  vpc_nat_multi_az_default = false
}

module "local_config" {
  source  = "path/to/modules/local_config"
  content = local.output_data
  std_map = module.com_lib.std_map
}
