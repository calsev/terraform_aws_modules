module "name_map" {
  source                          = "../../name_map"
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  std_map                         = var.std_map
}

locals {
  ci_cd_deploy_data_map = {
    for k, v in local.lx_map : k => {
      build_map = merge(
        module.code_build.data[k].build_map,
        v.image_build_enabled ? module.image_build.data[k].build_map : null,
      )
    }
  }
  create_cicd_build_map = {
    for k, v in local.lx_map : k => merge(v, {
      build_map = {
        pipe_deploy = {
          environment_type    = "cpu-arm-amazon-small"
          iam_role_arn        = module.code_build_role[k].data.iam_role_arn
          input_artifact_list = [v.build_artifact_name]
          source_build_spec   = v.path_repo_root_to_deploy_spec # TODO: Non blue-green?
          source_type         = "CODEPIPELINE"
        }
      }
    })
  }
  create_ci_cd_image_map = {
    for k, v in local.lx_map : k => merge(v, {
      role_policy_attach_arn_map   = v.build_role_policy_attach_arn_map
      role_policy_create_json_map  = v.build_role_policy_create_json_map
      role_policy_inline_json_map  = v.build_role_policy_inline_json_map
      role_policy_managed_name_map = v.build_role_policy_managed_name_map
    }) if v.image_build_enabled
  }
  create_cicd_pipe_map = {
    for k, v in local.lx_map : k => merge(v, {
      deploy_stage_list = concat(
        v.image_build_enabled ? [
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
        ] : [],
        [
          {
            action_map = {
              CodeDeployTrigger = {
                # The CodeDeploy integration insists on managing the task as well, so we use CodeBuild, see
                # https://docs.aws.amazon.com/codepipeline/latest/userguide/action-reference-ECSbluegreen.html#action-reference-ECSbluegreen-config
                configuration_build_project_key = "pipe_deploy"
                input_artifact_list             = [v.build_artifact_name]
              }
            }
            name = "ServiceDeploy"
          },
        ],
      )
    })
  }
  create_cluster_map = {
    for k, v in local.lx_map : k => v if !var.use_fargate
  }
  create_fargate_map = {
    for k, v in local.lx_map : k => v if var.use_fargate
  }
  create_file_app_spec_1_map = {
    for k, v in local.lx_map : k => merge(v, {
      app_spec = {
        Resources = [
          {
            TargetService = {
              Properties = {
                CapacityProviderStrategy = [
                  {
                    Base = 0
                    CapacityProvider : local.ecs_cluster_data[k].capacity_provider_name
                    Weight = 100
                  },
                ]
                LoadBalancerInfo = {
                  ContainerName = module.ecs_service.data[k].elb_target_map[keys(v.deployment_map)[0]].container_name
                  ContainerPort = module.ecs_service.data[k].elb_target_map[keys(v.deployment_map)[0]].container_port
                }
                TaskDefinition = module.ecs_task.data[k].task_definition_arn_latest
              }
              Type = "AWS::ECS::Service"
            }
          }
        ]
        version = "0.0"
      }
    }) if v.deployment_style_use_blue_green
  }
  create_file_app_spec_x_map = {
    for k, v in local.create_file_app_spec_1_map : k => merge(v, {
      revision_spec = {
        applicationName     = module.codedeploy_app.data[k].name_effective
        deploymentGroupName = module.codedeploy_group.data[k].name_effective
        revision = {
          appSpecContent = {
            content = v.app_spec
          }
          revisionType = "AppSpecContent"
        }
      }
    })
  }
  create_file_deploy_script_map = {
    for k, v in local.create_file_app_spec_1_map : k => merge(v, {
      deploy_script = templatefile("${path.module}/deploy_script.sh", {
        codedeploy_application_name = module.codedeploy_app.data[k].name_effective
        deployment_group_name       = module.codedeploy_group.data[k].name_effective
        app_spec_content            = replace(jsonencode(v.app_spec), "\"", "\\\"")
        app_spec_sha256             = sha256(jsonencode(v.app_spec))
      })
    }) # TODO: Non blue-green?
  }
  create_file_deploy_spec_map = {
    for k, v in local.lx_map : k => merge(v, {
      deploy_spec = templatefile("${path.module}/deploy_spec.yml", {
        path_repo_root_to_deploy_script = v.path_repo_root_to_deploy_script
      })
    })
  }
  create_deployment_map = {
    for k, v in local.lx_map : k => merge(v, {
      deployment_environment_map = merge(
        { blue = {} }, # TODO: Non blue-green enumeration
        v.deployment_style_use_blue_green ? { green = {} } : {}
      )
      ecs_service_map = {
        (k) = {
          cluster_key = k
        }
      }
    })
  }
  create_service_map = {
    for k, v in local.lx_map : k => merge(v, {
      elb_target_map = {
        for k_targ, v_targ in v.elb_target_map : "${k}_${k_targ}" => v_targ
      }
    })
  }
  create_target_1_list = flatten([
    for k, v in local.lx_map : [
      for k_dep, v_dep in v.listen_target_map : merge(v, v_dep, {
        k_dep = k_dep
      })
    ]
  ])
  create_target_x_map = {
    for v in local.create_target_1_list : v.k_dep => v
  }
  create_task_map = {
    for k, v in local.lx_map : k => merge(v, {
      container_definition_map = {
        for k_container, v_container in v.container_definition_map : k_container => merge(v_container, {
          image = v_container.image == null ? v.image_has_default ? "${var.ecr_data_map[v.image_ecr_repo_key].repo_url}:${v.image_tag_base}" : null : v_container.image
        })
      }
      ecs_cluster_key = k
    })
  }
  ecs_cluster_data = var.use_fargate ? module.fargate_cluster.data : module.ecs_cluster.data
  l0_map = {
    for k, v in var.app_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      acm_certificate_key              = v.acm_certificate_key == null ? var.listener_acm_certificate_key_default : v.acm_certificate_key
      app_action_order_default_forward = v.app_action_order_default_forward == null ? var.app_action_order_default_forward_default : v.app_action_order_default_forward
      build_artifact_name              = v.build_artifact_name == null ? var.pipe_build_artifact_name_default : v.build_artifact_name
      deployment_style_use_blue_green  = v.elb_target_map == null ? v.deployment_style_use_blue_green == null ? var.deployment_style_use_blue_green_default : v.deployment_style_use_blue_green : false
      desired_count                    = v.desired_count == null ? var.service_desired_count_default : v.desired_count
      elb_target_map = v.elb_target_map == null ? var.service_elb_target_map_default == null ? { blue = {
        container_name = null
        container_port = null
      } } : var.service_elb_target_map_default : v.elb_target_map
      image_build_arch_list            = v.image_build_arch_list == null ? var.build_image_build_arch_list_default : v.image_build_arch_list
      image_ecr_repo_key               = v.image_ecr_repo_key == null ? var.build_image_ecr_repo_key_default : v.image_ecr_repo_key
      image_tag_base                   = v.image_tag_base == null ? var.build_image_tag_base_default : v.image_tag_base
      path_include_env                 = v.path_include_env == null ? var.app_path_include_env_default : v.path_include_env
      path_repo_root_to_spec_directory = v.path_repo_root_to_spec_directory == null ? var.app_path_repo_root_to_spec_directory_default : v.path_repo_root_to_spec_directory
      path_terraform_app_to_repo_root  = trim(v.path_terraform_app_to_repo_root == null ? var.app_path_terraform_app_to_repo_root_default : v.path_terraform_app_to_repo_root, "/")
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      auto_scaling_num_instances_max = local.l1_map[k].desired_count * 2
      deployment_map = local.l1_map[k].deployment_style_use_blue_green ? {
        "${k}_blue" = {
          listen_port = var.app_deployment_listen_port_prod_default
        }
        "${k}_green" = {
          listen_port = var.app_deployment_listen_port_test_default
        }
        } : {
        for k_targ, v_targ in local.l1_map[k].elb_target_map : "${k}_${k_targ}" => {
          listen_port = var.app_deployment_listen_port_prod_default # No blue green so always prod
        }
      }
      image_build_enabled = length(local.l1_map[k].image_build_arch_list) != 0
      image_has_default   = var.ecr_data_map != null && local.l1_map[k].image_ecr_repo_key != null && local.l1_map[k].image_tag_base != null
      path_env_suffix     = local.l1_map[k].path_include_env ? "_${var.std_map.env}" : ""
      rule_condition_map = merge(v.rule_condition_map == null ? var.rule_condition_map_default : v.rule_condition_map, {
        # TODO: Per target rules
        host_match = merge({
          host_header_pattern_list = [var.dns_data.region_domain_cert_map[var.std_map.aws_region_name][local.l1_map[k].acm_certificate_key].name_simple]
        })
      })
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      listen_target_map = {
        for k_dep, v_dep in local.l2_map[k].deployment_map : k_dep => merge(v_dep, {
          action_map = merge(v.action_map == null ? var.listener_action_map_default : v.action_map, {
            forward_to_service = {
              action_forward_target_group_map = {
                (k_dep) = {}
              }
              action_order = local.l1_map[k].app_action_order_default_forward
              action_type  = "forward"
            }
          })
        })
      }
      path_repo_root_to_deploy_script     = "${local.l1_map[k].path_repo_root_to_spec_directory}/${k}_deploy${local.l2_map[k].path_env_suffix}.sh"
      path_repo_root_to_deploy_spec       = "${local.l1_map[k].path_repo_root_to_spec_directory}/${k}_deploy${local.l2_map[k].path_env_suffix}.yml"
      path_terraform_app_to_deploy_script = "${local.l1_map[k].path_terraform_app_to_repo_root}/${local.l1_map[k].path_repo_root_to_spec_directory}/${k}_deploy${local.l2_map[k].path_env_suffix}.sh"
      path_terraform_app_to_deploy_spec   = "${local.l1_map[k].path_terraform_app_to_repo_root}/${local.l1_map[k].path_repo_root_to_spec_directory}/${k}_deploy${local.l2_map[k].path_env_suffix}.yml"
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        ci_cd_build   = module.code_build.data[k]
        ci_cd_image   = v.image_build_enabled ? module.image_build.data[k] : null
        ci_cd_pipe    = module.code_pipe.data[k]
        cluster       = local.ecs_cluster_data[k]
        deploy_app    = module.codedeploy_app.data[k]
        deploy_config = module.codedeploy_config.data[k]
        deploy_group  = module.codedeploy_group.data[k]
        elb_listener_map = {
          for k_dep, _ in v.deployment_map : k_dep => module.elb_listener.data[k_dep]
        }
        elb_target_map = {
          for k_dep, _ in v.deployment_map : k_dep => module.elb_target.data[k_dep]
        }
        iam = {
          role = {
            ci_cd_build = module.code_build_role[k].data
          }
        }
        service = module.ecs_service.data[k]
        task    = module.ecs_task.data[k]
      }
    )
  }
}
