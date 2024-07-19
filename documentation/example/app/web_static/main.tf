provider "aws" {
  region = local.std_var.aws_region_name
}

module "com_lib" {
  source  = "path/to/modules/common"
  std_var = local.std_var
}

module "code_build" {
  source             = "path/to/modules/ci_cd/build"
  ci_cd_account_data = data.terraform_remote_state.ci_cd.outputs.data
  repo_map = {
    "example.com" = {
      build_map = {
        pipe_build = {
          source_build_spec = "build_spec/build.yml"
          source_type       = "CODEPIPELINE"
        }
      }
    }
  }
  build_source_git_clone_depth_default = 5
  std_map                              = module.com_lib.std_map
}

module "web_app" {
  source                                       = "path/to/modules/app/web_static"
  bucket_log_target_bucket_name_default        = "example-log"
  cdn_global_data                              = data.terraform_remote_state.cdn_global.outputs.data
  ci_cd_account_data                           = data.terraform_remote_state.ci_cd.outputs.data
  ci_cd_build_data_map                         = module.code_build.data
  dns_data                                     = data.terraform_remote_state.dns.outputs.data
  domain_dns_from_zone_key_default             = "example.com"
  domain_logging_bucket_key_default            = "aws_waf_logs_example_global"
  pipe_source_code_star_connection_key_default = "github_example"
  pipe_webhook_secret_is_param_default         = true
  s3_data_map                                  = data.terraform_remote_state.cdn_global.outputs.data.s3_bucket
  site_map = {
    "example.com" = {
      build_stage_list = [
        {
          action_map = {
            Build = {
              configuration_build_project_key = "pipe_build"
              output_artifact_list            = ["site"]
            }
          }
          name = "Build"
        },
      ]
      origin_fqdn          = "site-bucket.example.com"
      source_repository_id = "example/web_client"
    }
  }
  std_map = module.com_lib.std_map
}

module "local_config" {
  source  = "path/to/modules/local_config"
  content = local.output_data
  std_map = module.com_lib.std_map
}
