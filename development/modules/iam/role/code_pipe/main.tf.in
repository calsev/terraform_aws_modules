{{ iam.policy_identity_ar_type(policy_name="start_build", suffix="code_build/project") }}

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
  {{ name.map_item() }}
  {{ iam.role_map_item() }}
  std_map                              = var.std_map
}
