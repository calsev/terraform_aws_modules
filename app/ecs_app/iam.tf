module "service_deploy_policy" {
  source       = "../../iam/policy/identity/ecs/service"
  for_each     = local.create_ci_cd_deploy_policy_map
  name         = "${each.key}_service_deploy"
  cluster_name = each.value.ecs_cluster_name
  service_name = each.value.ecs_service_name
  std_map      = var.std_map
}

module "code_build_role" {
  source             = "../../iam/role/code_build"
  for_each           = local.lx_map
  ci_cd_account_data = var.ci_cd_account_data
  role_policy_attach_arn_map_default = each.value.deployment_uses_codedeploy ? {} : {
    deploy_service = module.service_deploy_policy[each.key].data.iam_policy_arn_map["read_write"]
  }
  role_policy_managed_name_map_default = each.value.deployment_uses_codedeploy ? {
    deploy_start = "AWSCodeDeployDeployerAccess"
  } : {}
  name       = "${each.key}_deploy"
  std_map    = var.std_map
  vpc_access = var.build_vpc_access_default
}
