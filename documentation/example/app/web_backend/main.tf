provider "aws" {
  region = local.aws_region_name
}

module "com_lib" {
  source   = "path/to/modules/common"
  for_each = local.env_list
  std_var  = local.std_var_map[each.key]
}

module "ecs_app" {
  source   = "path/to/modules/app/ecs_app"
  for_each = local.env_list
  app_map = {
    web = {
      acm_certificate_key = {
        dev = "web_dev.example.com"
        prd = "web.example.com"
      }[each.key]
      build_stage_list = []
      container_definition_map = {
        server = {
          image = "public.ecr.aws/ubuntu/nginx:latest"
        },
      }
      desired_count = {
        dev = 0
        prd = 1
      }[each.key]
    }
  }
  app_path_repo_root_to_spec_directory_default = "app/web_backend/spec"
  app_path_terraform_app_to_repo_root_default  = "../../../.."
  ci_cd_account_data                           = data.terraform_remote_state.ci_cd.outputs.data
  ci_cd_build_data_map                         = {}
  cognito_data_map                             = data.terraform_remote_state.core.outputs.data["com"].user_pool
  dns_data                                     = data.terraform_remote_state.dns.outputs.data
  listener_dns_from_zone_key_default           = "example.com"
  elb_data_map                                 = data.terraform_remote_state.net.outputs.data.elb_map
  iam_data                                     = data.terraform_remote_state.iam.outputs.data
  listener_elb_key_default                     = "main"
  monitor_data                                 = data.terraform_remote_state.monitor.outputs.data
  pipe_build_artifact_name_default             = "SourceArtifact"
  pipe_source_code_star_connection_key_default = "github_example"
  pipe_source_repository_id_default            = "example/repo"
  pipe_webhook_secret_is_param_default         = true
  std_map                                      = module.com_lib[each.key].std_map
  target_health_check_http_path_default        = "/"
  task_container_entry_point_default           = null
  vpc_data_map                                 = data.terraform_remote_state.net.outputs.data.vpc_map
  vpc_key_default                              = "main"
}

module "local_config" {
  source   = "path/to/modules/local_config"
  for_each = local.env_list
  content  = local.output_data[each.key]
  std_map  = module.com_lib[each.key].std_map
}
