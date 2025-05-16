module "name_map" {
  source                          = "../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
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
      build_environment_size     = v.build_environment_size == null ? var.build_environment_size_default : v.build_environment_size
      code_star_connection_key   = v.code_star_connection_key == null ? var.build_code_star_connection_key_default : v.code_star_connection_key
      image_build_arch_list      = v.image_build_arch_list == null ? var.build_image_build_arch_list_default : v.image_build_arch_list
      image_ecr_repo_key         = v.image_ecr_repo_key == null ? var.build_image_ecr_repo_key_default : v.image_ecr_repo_key
      image_environment_key_arch = v.image_environment_key_arch == null ? var.build_image_environment_key_arch_default : v.image_environment_key_arch
      image_environment_key_tag  = v.image_environment_key_tag == null ? var.build_image_environment_key_tag_default : v.image_environment_key_tag
      image_tag_base             = v.image_tag_base == null ? var.build_image_tag_base_default : v.image_tag_base
      source_build_spec_image    = v.source_build_spec_image == null ? var.build_source_build_spec_image_default : v.source_build_spec_image
      source_build_spec_manifest = v.source_build_spec_manifest == null ? var.build_source_build_spec_manifest_default : v.source_build_spec_manifest
      vpc_access                 = v.vpc_access == null ? var.build_vpc_access_default : v.vpc_access
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      build_map = merge(
        # Create a build array for each repo, injecting common values for the repo
        contains(local.l1_map[k].image_build_arch_list, "amd") ? {
          pipe_image_amd = merge(local.l1_map[k], local.repo_build_image_common, {
            environment_type = "cpu-amd-amazon-${local.l1_map[k].build_environment_size}"
            environment_variable_map = {
              (local.l1_map[k].image_environment_key_arch) = {
                type  = "PLAINTEXT"
                value = "linux/amd64"
              }
              (local.l1_map[k].image_environment_key_tag) = {
                type  = "PLAINTEXT"
                value = "${local.l1_map[k].image_tag_base}-amd"
              }
            }
            source_build_spec = local.l1_map[k].source_build_spec_image
          })
        } : {},
        contains(local.l1_map[k].image_build_arch_list, "arm") ? {
          pipe_image_arm = merge(local.l1_map[k], local.repo_build_image_common, {
            environment_type = "cpu-arm-amazon-${local.l1_map[k].build_environment_size}"
            environment_variable_map = {
              (local.l1_map[k].image_environment_key_arch) = {
                type  = "PLAINTEXT"
                value = "linux/arm64"
              }
              (local.l1_map[k].image_environment_key_tag) = {
                type  = "PLAINTEXT"
                value = "${local.l1_map[k].image_tag_base}-arm"
              }
            }
            source_build_spec = local.l1_map[k].source_build_spec_image
          })
        } : {},
        {
          pipe_image_manifest = merge(local.repo_build_image_common, {
            environment_variable_map = {
              (local.l1_map[k].image_environment_key_tag) = {
                type  = "PLAINTEXT"
                value = local.l1_map[k].image_tag_base
              }
            }
            source_build_spec = local.l1_map[k].source_build_spec_manifest
          })
        },
      )
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
        build_stage_list = [
          {
            action_map = {
              for arch in v.image_build_arch_list : title(arch) => {
                configuration_build_project_key = "pipe_image_${lower(arch)}"
              }
            }
            name = "ImageBuild"
          },
          {
            action_map = {
              Deploy = {
                configuration_build_project_key = "pipe_image_manifest"
              }
            }
            name = "ImageManifest"
          },
        ]
        role = module.image_build_role[k].data
      }
    )
  }
  repo_build_image_common = {
    environment_privileged_mode = true
    source_type                 = "CODEPIPELINE"
  }
}
