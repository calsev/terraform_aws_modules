module "net_policy" {
  source  = "../../iam/policy/identity/code_build/net"
  name    = "vpc_net"
  std_map = var.std_map
}

module "basic_build_role" {
  source = "../../iam/role/code_build"
  ci_cd_account_data = {
    # We emulate this here of course :)
    bucket = module.build_bucket.data[local.bucket_name]
    code_star = {
      connection = {}
    }
    log    = module.build_log.data[local.base_name]
    policy = null
  }
  name        = "build_basic"
  name_prefix = var.policy_name_prefix
  std_map     = var.std_map
}

module "public_log_access_role" {
  for_each                 = var.log_public_enabled ? { this = {} } : {}
  source                   = "../../iam/role/base"
  assume_role_service_list = ["codebuild"]
  name                     = "log_access_public"
  role_policy_attach_arn_map_default = {
    log = module.build_log.data[local.public_name].iam_policy_arn_map.public_read
  }
  std_map = var.std_map
}

module "code_deploy_ecs" {
  source                   = "../../iam/role/base"
  assume_role_service_list = ["codedeploy"]
  name                     = "codedeploy_ecs"
  role_policy_attach_arn_map_default = {
    artifact_read_write = module.build_bucket.data[local.bucket_name].policy.iam_policy_arn_map["read_write"]
  }
  role_policy_managed_name_map_default = {
    codedeploy_ec2 = "service-role/AWSCodeDeployRole"
    codedeploy_ecs = "AWSCodeDeployRoleForECS"
  }
  std_map = var.std_map
}

module "code_deploy_lamba" {
  source                   = "../../iam/role/base"
  assume_role_service_list = ["codedeploy"]
  name                     = "codedeploy_lambda"
  role_policy_attach_arn_map_default = {
    artifact_read_write = module.build_bucket.data[local.bucket_name].policy.iam_policy_arn_map["read_write"]
  }
  role_policy_managed_name_map_default = {
    codedeploy_lambda = "service-role/AWSCodeDeployRoleForLambda"
  }
  std_map = var.std_map
}
