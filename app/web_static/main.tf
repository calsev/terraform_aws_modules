module "cdn" {
  source                            = "../../cdn/distribution"
  cdn_global_data                   = var.cdn_global_data
  domain_dns_from_zone_key_default  = var.domain_dns_from_zone_key_default
  domain_map                        = local.lx_map
  domain_origin_dns_enabled_default = var.domain_origin_dns_enabled_default
  dns_data                          = var.dns_data
  name_include_app_fields_default   = var.name_include_app_fields_default
  name_infix_default                = var.name_infix_default
  std_map                           = var.std_map
}

module "code_build" {
  source                          = "../../ci_cd/build"
  ci_cd_account_data              = var.ci_cd_account_data
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  repo_map                        = local.create_build_map
  std_map                         = var.std_map
}

module "pipe" {
  source                                       = "../../ci_cd/pipe_stack"
  ci_cd_account_data                           = var.ci_cd_account_data
  ci_cd_build_data_map                         = var.ci_cd_build_data_map
  ci_cd_deploy_data_map                        = module.code_build.data
  name_include_app_fields_default              = var.name_include_app_fields_default
  name_infix_default                           = var.name_infix_default
  pipe_map                                     = local.create_pipe_map
  pipe_source_branch_default                   = var.pipe_source_branch_default
  pipe_source_code_star_connection_key_default = var.pipe_source_code_star_connection_key_default
  pipe_source_repository_id_default            = var.pipe_source_repository_id_default
  pipe_webhook_enable_github_hook_default      = var.pipe_webhook_enable_github_hook_default
  pipe_webhook_secret_is_param_default         = var.pipe_webhook_secret_is_param_default
  std_map                                      = var.std_map
}
