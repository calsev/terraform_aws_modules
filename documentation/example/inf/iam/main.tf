provider "aws" {
  region = local.std_var.aws_region_name
}

module "com_lib" {
  source  = "path/to/modules/common"
  std_var = local.std_var
}

resource "aws_iam_account_alias" "account_alias" {
  account_alias = "example"
}

module "backup_iam" {
  source  = "path/to/modules/iam/app/backup"
  std_map = module.com_lib.std_map
}

module "batch_iam" {
  source  = "path/to/modules/iam/app/batch"
  std_map = module.com_lib.std_map
}

module "ec2_iam" {
  source  = "path/to/modules/iam/app/ec2"
  std_map = module.com_lib.std_map
}

module "ecr_iam" {
  source  = "path/to/modules/iam/app/ecr"
  std_map = module.com_lib.std_map
}

module "ecs_iam" {
  source       = "path/to/modules/iam/app/ecs"
  monitor_data = data.terraform_remote_state.monitor.outputs.data
  std_map      = module.com_lib.std_map
}

module "lambda_iam" {
  source  = "path/to/modules/iam/app/lambda"
  std_map = module.com_lib.std_map
}

module "rds_iam" {
  source  = "path/to/modules/iam/app/rds"
  std_map = module.com_lib.std_map
}

module "support_iam" {
  source  = "path/to/modules/iam/app/support"
  std_map = module.com_lib.std_map
}

module "secrets" {
  source = "path/to/modules/ssm/parameter_secret"
  param_map = {
    user_pgp_key = {
      policy_create = false # No use cases for resources reading this
    }
  }
  std_map = module.com_lib.std_map
}

module "password_policy" {
  source = "path/to/modules/iam/user/password_policy"
}

module "users" {
  source = "path/to/modules/iam/user_group"
  group_map = {
    admin = {
      k_user_list = [
        "some_user",
      ]
      name_infix = false
      policy_managed_name_map = {
        admin   = "AdministratorAccess"
        billing = "job-function/Billing"
        support = "AWSSupportAccess" # Appease Security Hub
      }
    }
  }
  user_map = {
    some_user = {
      enable_console_access = true
      name_infix            = false
    }
  }
  std_map = module.com_lib.std_map
}

module "key_pair" {
  source = "path/to/modules/ec2/key_pair"
  key_map = {
    admin_key = {}
  }
  key_secret_is_param_default = true
  std_map                     = module.com_lib.std_map
}

module "local_config" {
  source  = "path/to/modules/local_config"
  content = local.output_data
  std_map = module.com_lib.std_map
}
