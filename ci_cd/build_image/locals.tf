module "name_map" {
  source                          = "../../name_map"
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  std_map                         = var.std_map
}

locals {
  create_build_map = {
    for k, v in local.lx_map : k => merge(v, {
      build_map = {
        for k_build, v_build in v.build_map : k_build => merge(v_build, {
          iam_role_arn = module.image_build_role[k].data.iam_role_arn
        })
      }
    })
  }
  l0_map = {
    for k, v in var.repo_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      code_star_connection_key   = v.code_star_connection_key == null ? var.build_code_star_connection_key_default : v.code_star_connection_key
      ecr_repo_key               = v.ecr_repo_key == null ? var.build_ecr_repo_key_default : v.ecr_repo_key
      environment_key_arch       = v.environment_key_arch == null ? var.build_environment_key_arch_default : v.environment_key_arch
      environment_key_tag        = v.environment_key_tag == null ? var.build_environment_key_tag_default : v.environment_key_tag
      image_tag_base             = v.image_tag_base == null ? var.build_image_tag_base_default : v.image_tag_base
      source_build_spec_image    = v.source_build_spec_image == null ? var.build_source_build_spec_image_default : v.source_build_spec_image
      source_build_spec_manifest = v.source_build_spec_manifest == null ? var.build_source_build_spec_manifest_default : v.source_build_spec_manifest
      vpc_access                 = v.vpc_access == null ? var.build_vpc_access_default : v.vpc_access
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      build_map = {
        # Create a build array for each repo, injecting common values for the repo
        pipe_image_amd = merge(local.l1_map[k], local.repo_build_image_common, {
          environment_variable_map = {
            (local.l1_map[k].environment_key_arch) = {
              type  = "PLAINTEXT"
              value = "linux/amd64"
            }
            (local.l1_map[k].environment_key_tag) = {
              type  = "PLAINTEXT"
              value = "${local.l1_map[k].image_tag_base}-amd"
            }
          }
          source_build_spec = local.l1_map[k].source_build_spec_image
        })
        pipe_image_arm = merge(local.repo_build_image_common, {
          environment_type = "cpu-arm-amazon-small"
          environment_variable_map = {
            (local.l1_map[k].environment_key_arch) = {
              type  = "PLAINTEXT"
              value = "linux/arm64"
            }
            (local.l1_map[k].environment_key_tag) = {
              type  = "PLAINTEXT"
              value = "${local.l1_map[k].image_tag_base}-arm"
            }
          }
          source_build_spec = local.l1_map[k].source_build_spec_image
        })
        pipe_image_manifest = merge(local.repo_build_image_common, {
          environment_variable_map = {
            (local.l1_map[k].environment_key_tag) = {
              type  = "PLAINTEXT"
              value = local.l1_map[k].image_tag_base
            }
          }
          source_build_spec = local.l1_map[k].source_build_spec_manifest
        })
      }
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      module.code_build.data[k],
      {
        role = module.image_build_role[k].data
      }
    )
  }
  repo_build_image_common = {
    environment_privileged_mode = true
    source_type                 = "CODEPIPELINE"
  }
}
