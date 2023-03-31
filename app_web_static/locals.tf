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
            bucket_name           = module.cdn.data.bucket[k].name_effective
            cdn_distribution_id   = module.cdn.data.cdn[k].id
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
  domain_object = {
    for k, v in var.site_map : k => {
      domain_name   = v.domain_name == null ? var.site_domain_name_default : v.domain_name
      origin_domain = v.bucket_domain
      origin_fqdn   = v.bucket_fqdn
    }
  }
  output_data = merge(module.cdn.data, {
    build = module.code_build.data
  })
  pipe_map = {
    for k, v in var.site_map : "${k}_deploy_${var.std_map.env}" => {
      iam_role_arn         = module.code_pipe_role[k].data.iam_role_arn
      source_branch        = v.source_branch
      source_repository_id = v.source_repository_id
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
    }
  }
  site_policy_map = {
    for k, v in var.site_map : k => {
      attach_policy_arn_map = merge(v.iam_policy_arn_attach_map == null ? {} : v.iam_policy_arn_attach_map, {
        build_start     = module.start_build[k].data.iam_policy_arn_map.read_write
        code_connection = var.ci_cd_account_data.code_star.connection[var.code_star_connection_name].iam_policy_arn_map.read_write
        source_write    = var.ci_cd_account_data.bucket.iam_policy_arn_map.write
      })
      inline_policy_json_map  = v.iam_policy_json_inline_map
      managed_policy_name_map = v.iam_policy_name_managed_map
    }
  }
}
