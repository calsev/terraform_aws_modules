module "code_build" {
  source             = "../../ci_cd/build"
  ci_cd_account_data = var.ci_cd_account_data
  repo_map           = local.build_map
  std_map            = var.std_map
}

module "code_pipe" {
  source                              = "../../ci_cd/pipe"
  ci_cd_account_data                  = var.ci_cd_account_data
  pipe_map                            = local.pipe_map
  pipe_source_connection_name_default = var.code_star_connection_name
  std_map                             = var.std_map
}
