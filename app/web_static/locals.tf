locals {
  artifact_name_map = {
    for k, v in var.site_map : k => v.build_artifact_name == null ? var.site_build_artifact_name_default : v.build_artifact_name
  }
  build_map = {
    for k, v in var.site_map : "web-${k}" => {
      build_map = {
        deploy = {
          environment_type    = "cpu-arm-amazon-small"
          iam_role_arn        = module.code_build_role[k].data.iam_role_arn
          input_artifact_list = [local.artifact_name_map[k]]
          source_build_spec = templatefile("${path.module}/deploy_spec.yml", {
            bucket_name           = module.cdn.data[k].bucket.name_effective
            cdn_distribution_id   = module.cdn.data[k].cdn_id
            cdn_invalidation_path = v.cdn_invalidation_path == null ? var.site_cdn_invalidation_path_default : v.cdn_invalidation_path
            local_sync_path       = v.build_artifact_sync_path == null ? var.site_build_artifact_sync_path_default : v.build_artifact_sync_path
          })
          source_type = "CODEPIPELINE"
        }
      }
    }
  }
  build_name_list_map = {
    for k, v_site in var.site_map : k => concat(
      [for v_build in v_site.build_list : v_build.build_project_name],
      [module.code_build.data["web-${k}"].deploy.name],
    )
  }
  create_cdn_map = {
    for k, v in var.site_map : k => merge(v, {
    })
  }
  output_data = {
    for k, v in var.site_map : k => {
      cdn        = module.cdn.data[k],
      code_build = module.code_build.data["web-${k}"]
      code_pipe  = module.code_pipe.data["${k}_deploy_${var.std_map.env}"]
      policy = {
        cdn_invalidate = module.cdn_invalidate[k].data
        site_deploy    = module.site_deploy[k].data
      }
      role = {
        code_build = module.code_build_role[k].data
        code_pipe  = module.code_pipe_role[k].data
      }
    }
  }
  pipe_map = {
    for k, v in var.site_map : "${k}_deploy_${var.std_map.env}" => merge(v, {
      iam_role_arn    = module.code_pipe_role[k].data.iam_role_arn
      secret_is_param = v.ci_cd_pipeline_webhook_secret_is_param
      stage_list = concat(
        [
          for project in v.build_list : {
            action_map = {
              (project.name) = {
                configuration_project_name = project.build_project_name
                output_artifact_list       = project.output_artifact_list
              }
            }
            name = project.name
          }
        ],
        [
          {
            action_map = {
              Deploy = {
                configuration_project_name = module.code_build.data["web-${k}"].deploy.name
                input_artifact_list        = [local.artifact_name_map[k]]
              }
            }
            name = "Deploy"
          },
        ]
      )
    })
  }
}
