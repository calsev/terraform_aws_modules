provider "aws" {
  region = local.std_var.aws_region_name
}

module "com_lib" {
  source  = "path/to/modules/common"
  std_var = local.std_var
}

module "efs" {
  source  = "path/to/modules/efs"
  std_map = module.com_lib.std_map
  fs_map = {
    cache = {}
  }
  vpc_key_default = "main"
  vpc_data_map    = data.terraform_remote_state.net.outputs.data.vpc_map
}

module "code_build" {
  source             = "path/to/modules/ci_cd/build"
  ci_cd_account_data = data.terraform_remote_state.ci_cd.outputs.data
  repo_map = {
    acs = {
      build_map = {
        pipe_test = merge(local.build_test_unit_common, {
          source_type = "CODEPIPELINE"
        })
        test = merge(local.build_test_unit_common, {
          iam_role_arn                 = module.public_build_role.data.iam_role_arn
          iam_role_arn_resource_access = data.terraform_remote_state.ci_cd.outputs.data.role.build.log_public_read.iam_role_arn # This is for public access
          log_s3_bucket_name           = data.terraform_remote_state.s3.outputs.data.bucket[module.com_lib.std_map.aws_region_name]["example_log_public"].name_effective
          log_s3_enabled               = true
          log_s3_encryption_disabled   = true
          public_visibility            = true
        })
      }
      source_location_default = "https://github.com/example/some-repo"
    }
  }
  build_iam_role_arn_default           = module.basic_build_role.data.iam_role_arn
  build_source_git_clone_depth_default = 5
  build_webhook_filter_map_default = {
    main = {
      main = {
        pattern = "main"
        type    = "HEAD_REF"
      }
      pushed = {
        pattern = "PUSH"
        type    = "EVENT"
      }
    }
    pr = {
      updated = {
        pattern = "PULL_REQUEST_CREATED, PULL_REQUEST_UPDATED, PULL_REQUEST_REOPENED"
        type    = "EVENT"
      }
    }
  }
  std_map         = module.com_lib.std_map
  vpc_data_map    = data.terraform_remote_state.net.outputs.data.vpc_map
  vpc_key_default = "main"
}

module "code_pipe" {
  source               = "path/to/modules/ci_cd/pipe_stack"
  ci_cd_account_data   = data.terraform_remote_state.ci_cd.outputs.data
  ci_cd_build_data_map = module.code_build.data
  pipe_map = {
    acs = {
      source_branch        = "main"
      source_repository_id = "example/some-repo"
      build_stage_list = [
        {
          action_map = {
            Test = {
              configuration_build_project_key = "pipe_test"
            }
          }
          name = "Test"
        },
      ]
    }
  }
  pipe_source_code_star_connection_key_default = "github_example"
  pipe_webhook_secret_is_param_default         = true
  std_map                                      = module.com_lib.std_map
}

module "local_config" {
  source  = "path/to/modules/local_config"
  content = local.output_data
  std_map = module.com_lib.std_map
}
