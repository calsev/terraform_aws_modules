module "code_build" {
  source                              = "../../ci_cd/build"
  ci_cd_account_data                  = var.ci_cd_account_data
  repo_map                            = local.create_build_map
  std_map                             = var.std_map
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_data_map                        = var.vpc_data_map
  vpc_key_default                     = var.vpc_key_default
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
  vpc_segment_key_default             = var.vpc_segment_key_default
}
