module "cdn" {
  source                            = "../../cdn/distribution"
  cdn_global_data                   = var.cdn_global_data
  domain_dns_from_zone_key_default  = var.site_dns_from_zone_key_default
  domain_map                        = local.create_cdn_map
  domain_origin_dns_enabled_default = var.site_origin_dns_enabled_default
  dns_data                          = var.dns_data
  std_map                           = var.std_map
}

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
  pipe_secret_is_param_default        = var.site_ci_cd_pipeline_webhook_secret_is_param_default
  pipe_source_connection_name_default = var.code_star_connection_key
  std_map                             = var.std_map
}
