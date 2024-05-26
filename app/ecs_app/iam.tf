module "code_build_role" {
  for_each           = local.lx_map
  source             = "../../iam/role/code_build"
  ci_cd_account_data = var.ci_cd_account_data
  role_policy_managed_name_map_default = {
    deploy_start = "AWSCodeDeployDeployerAccess"
  }
  name       = "${each.key}_deploy"
  std_map    = var.std_map
  vpc_access = var.build_vpc_access_default
}
