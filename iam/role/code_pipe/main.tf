module "start_build" {
  source                  = "../../../iam/policy/identity/code_build/project"
  for_each                = local.has_build ? { this = {} } : {}
  access_list             = ["read_write"]
  build_project_name_list = var.build_name_list
  name                    = var.name == null ? null : "${var.name}_build"
  name_infix              = var.name_infix
  name_prefix             = var.name_prefix
  std_map                 = var.std_map
}

module "this_role" {
  source                   = "../../../iam/role/base"
  assume_role_service_list = ["codepipeline"]
  create_instance_profile  = false
  embedded_role_policy_attach_arn_map = {
    build_start = {
      condition = local.has_build
      policy    = local.has_build ? module.start_build["this"].data.iam_policy_arn_map.read_write : null
    }
    code_connection = {
      policy = var.ci_cd_account_data.code_star.connection[var.code_star_connection_key].iam_policy_arn_map.read_write
    }
    source_read_write = {
      # Write is always required, but read can be required for e.g. CodeDeploy
      policy = var.ci_cd_account_data.bucket.policy.iam_policy_arn_map.read_write
    }
  }
  embedded_role_policy_managed_name_map = {
    deploy_start = {
      condition = local.has_deploy
      policy    = "AWSCodeDeployDeployerAccess"
    }
  }
  map_policy                           = var.map_policy
  max_session_duration_m               = var.max_session_duration_m
  name                                 = var.name
  name_infix                           = var.name_infix
  name_prefix                          = var.name_prefix
  role_policy_attach_arn_map_default   = var.role_policy_attach_arn_map_default
  role_policy_create_json_map_default  = var.role_policy_create_json_map_default
  role_policy_inline_json_map_default  = var.role_policy_inline_json_map_default
  role_policy_managed_name_map_default = var.role_policy_managed_name_map_default
  role_path                            = var.role_path
  std_map                              = var.std_map
}
