module "service_deploy_policy" {
  source     = "../../iam/policy/identity/ecs/service"
  policy_map = local.create_ci_cd_deploy_policy_map
  std_map    = var.std_map
}

module "code_build_role" {
  source             = "../../iam/role/code_build"
  for_each           = local.lx_map
  ci_cd_account_data = var.ci_cd_account_data
  name       = "${each.key}_deploy"
  role_policy_attach_arn_map_default = each.value.deployment_uses_codedeploy ? {} : {
    deploy_service = module.service_deploy_policy.data[each.key].policy_map["read_write"].iam_policy_arn
  }
  role_policy_managed_name_map_default = each.value.deployment_uses_codedeploy ? {
    deploy_start = "AWSCodeDeployDeployerAccess"
  } : {}
  role_path_default = var.role_path_default
  std_map    = var.std_map
  vpc_access = var.build_vpc_access_default
}
