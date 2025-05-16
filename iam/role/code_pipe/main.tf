module "start_build" {
  source                          = "../../../iam/policy/identity/code_build/project"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  policy_access_list_default      = var.policy_access_list_default
  policy_create_default           = var.policy_create_default
  policy_map                      = local.create_policy_map
  policy_name_append_default      = var.policy_name_append_default
  policy_name_prefix_default      = var.policy_name_prefix_default
  std_map                         = var.std_map
}

module "this_role" {
  source                   = "../../../iam/role/base"
  assume_role_service_list = ["codepipeline"]
  create_instance_profile  = false
  embedded_role_policy_attach_arn_map = {
    build_start = {
      condition = local.has_build
      policy    = local.has_build ? module.start_build.data[var.name].policy_map["read_write"].iam_policy_arn : null
    }
    code_connection = {
      policy = var.ci_cd_account_data.code_star.connection[var.code_star_connection_key].policy_map["read_write"].iam_policy_arn
    }
    source_read_write = {
      # Write is always required, but read can be required for e.g. CodeDeploy
      policy = var.ci_cd_account_data.bucket.policy.policy_map["read_write"].iam_policy_arn
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
  name_append_default                  = var.name_append_default
  name_include_app_fields_default      = var.name_include_app_fields_default
  name_infix_default                   = var.name_infix_default
  name_prefix_default                  = var.name_prefix_default
  name_prepend_default                 = var.name_prepend_default
  name_suffix_default                  = var.name_suffix_default
  role_policy_attach_arn_map_default   = var.role_policy_attach_arn_map_default
  role_policy_create_json_map_default  = var.role_policy_create_json_map_default
  role_policy_inline_json_map_default  = var.role_policy_inline_json_map_default
  role_policy_managed_name_map_default = var.role_policy_managed_name_map_default
  role_path_default                    = var.role_path_default
  std_map                              = var.std_map
}
