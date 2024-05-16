module "name_map" {
  source                          = "../../name_map"
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  std_map                         = var.std_map
}

locals {
  create_cicd_build_map = {
    for k, v in local.lx_map : k => merge(v, {
      build_map = {
        pipe_deploy = {
          environment_type    = "cpu-arm-amazon-small"
          iam_role_arn        = module.code_build_role[k].data.iam_role_arn
          input_artifact_list = [v.build_artifact_name]
          source_build_spec   = v.path_repo_root_to_deploy_spec
          source_type         = "CODEPIPELINE"
        }
      }
    })
  }
  create_cicd_pipe_map = {
    for k, v in local.lx_map : k => merge(v, {
      deploy_stage_list = [
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
      ]
    })
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
                    CapacityProvider : module.ecs_cluster.data[k].capacity_provider_name
                    Weight = 100
                  },
                ]
                LoadBalancerInfo = {
                  ContainerName = module.ecs_service.data[k].elb_container_name
                  ContainerPort = module.ecs_service.data[k].elb_container_port
                }
                TaskDefinition = module.ecs_task.data[k].task_definition_arn_latest
              }
              Type = "AWS::ECS::Service"
            }
          }
        ]
        version = "0.0"
      }
    })
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
    })
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
        { blue = {} },
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
      elb_target_group_key_list = ["${k}_blue"]
    })
  }
  create_target_1_list = flatten([
    for k, v in local.lx_map : [
      for k_dep in v.deployment_environment_list : merge(v, {
        action_map = merge(v.action_map, {
          forward_to_service = merge(v.action_map.forward_to_service, {
            action_forward_target_group_map = {
              "${k}_${k_dep}" = {}
            }
            action_order = 40000
          })
        })
        k_all       = "${k}_${k_dep}"
        listen_port = local.env_to_port_map[k_dep]
      })
    ]
  ])
  create_target_x_map = {
    for v in local.create_target_1_list : v.k_all => v
  }
  create_task_map = {
    for k, v in local.lx_map : k => merge(v, {
      ecs_cluster_key = k
    })
  }
  env_to_port_map = {
    # TODO: A hard code dependency on default ELB setup
    blue  = 443
    green = 8443
  }
  l0_map = {
    for k, v in var.app_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      acm_certificate_key              = v.acm_certificate_key == null ? var.listener_acm_certificate_key_default : v.acm_certificate_key
      action_map                       = v.action_map == null ? var.listener_action_map_default : v.action_map
      build_artifact_name              = v.build_artifact_name == null ? var.pipe_build_artifact_name_default : v.build_artifact_name
      deployment_style_use_blue_green  = v.deployment_style_use_blue_green == null ? var.deployment_style_use_blue_green_default : v.deployment_style_use_blue_green
      desired_count                    = v.desired_count == null ? var.service_desired_count_default : v.desired_count
      path_include_env                 = v.path_include_env == null ? var.app_path_include_env_default : v.path_include_env
      path_repo_root_to_spec_directory = v.path_repo_root_to_spec_directory == null ? var.app_path_repo_root_to_spec_directory_default : v.path_repo_root_to_spec_directory
      path_terraform_app_to_repo_root  = trim(v.path_terraform_app_to_repo_root == null ? var.app_path_terraform_app_to_repo_root_default : v.path_terraform_app_to_repo_root, "/")
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      action_map = merge(local.l1_map[k].action_map, {
        forward_to_service = {
          action_type = "forward"
        }
      })
      auto_scaling_num_instances_max = local.l1_map[k].desired_count * 2
      deployment_environment_list    = local.l1_map[k].deployment_style_use_blue_green ? ["blue", "green"] : ["blue"]
      path_env_suffix                = local.l1_map[k].path_include_env ? "_${var.std_map.env}" : ""
      rule_condition_map = {
        host_match = {
          host_header_pattern_list = [var.dns_data.region_domain_cert_map[var.std_map.aws_region_name][local.l1_map[k].acm_certificate_key].name_simple]
        }
      }
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
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
        ci_cd_build   = null # module.code_build.data[k]
        ci_cd_pipe    = module.code_pipe.data[k]
        cluster       = module.ecs_cluster.data[k]
        deploy_app    = module.codedeploy_app.data[k]
        deploy_config = module.codedeploy_config.data[k]
        deploy_group  = module.codedeploy_group.data[k]
        elb_listener_map = {
          for k_dep in v.deployment_environment_list : k_dep => module.elb_listener.data["${k}_${k_dep}"]
        }
        elb_target_map = {
          for k_dep in v.deployment_environment_list : k_dep => module.elb_target.data["${k}_${k_dep}"]
        }
        iam = {
          role = {
            ci_cd_build = null # module.code_build_role[k].data
          }
        }
        service = module.ecs_service.data[k]
        task    = module.ecs_task.data[k]
      }
    )
  }
}
