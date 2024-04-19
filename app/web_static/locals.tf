locals {
  create_build_map = {
    for k, v in local.lx_map : k => merge(v, {
      build_map = {
        pipe_deploy = {
          environment_type    = "cpu-arm-amazon-small"
          iam_role_arn        = module.code_build_role[k].data.iam_role_arn
          input_artifact_list = [v.build_artifact_name]
          source_build_spec = templatefile("${path.module}/deploy_spec.yml", {
            bucket_name           = module.cdn.data[k].bucket.name_effective
            cdn_distribution_id   = module.cdn.data[k].cdn_id
            cdn_invalidation_path = v.cdn_invalidation_path == null ? var.site_cdn_invalidation_path_default : v.cdn_invalidation_path
            local_sync_path       = v.build_artifact_sync_path == null ? var.site_build_artifact_sync_path_default : v.build_artifact_sync_path
          })
          source_type = "CODEPIPELINE"
        }
      }
    })
  }
  create_pipe_map = {
    for k, v in local.lx_map : k => merge(v, {
      deploy_stage_list = [
        {
          action_map = {
            Deploy = {
              configuration_build_project_key = "pipe_deploy"
              input_artifact_list             = [v.build_artifact_name]
            }
          }
          name = "Deploy"
        },
      ]
    })
  }
  l0_map = {
    for k, v in var.site_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      build_artifact_name = v.build_artifact_name == null ? var.pipe_build_artifact_name_default : v.build_artifact_name
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      module.pipe.data[k],
      {
        cdn        = module.cdn.data[k],
        code_build = module.code_build.data[k]
        role = merge(module.pipe.data[k].role, {
          code_build = module.code_build_role[k].data
        })
        policy = {
          cdn_invalidate = module.cdn_invalidate[k].data
          site_deploy    = module.site_deploy[k].data
        }
      }
    )
  }
}
