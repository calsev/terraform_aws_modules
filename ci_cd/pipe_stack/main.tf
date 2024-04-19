module "code_pipe" {
  source                                       = "../../ci_cd/pipe"
  ci_cd_account_data                           = var.ci_cd_account_data
  pipe_map                                     = local.create_pipe_map
  pipe_source_artifact_format_default          = var.pipe_source_artifact_format_default
  pipe_source_branch_default                   = var.pipe_source_branch_default
  pipe_source_code_star_connection_key_default = var.pipe_source_code_star_connection_key_default
  pipe_source_repository_id_default            = var.pipe_source_repository_id_default
  pipe_stage_category_default                  = var.pipe_stage_category_default
  pipe_webhook_enable_github_hook_default      = var.pipe_webhook_enable_github_hook_default
  pipe_webhook_secret_is_param_default         = var.pipe_webhook_secret_is_param_default
  std_map                                      = var.std_map
}
