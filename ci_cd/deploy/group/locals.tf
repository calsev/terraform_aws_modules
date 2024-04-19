module "name_map" {
  source                          = "../../../name_map"
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  std_map                         = var.std_map
}

locals {
  l0_map = {
    for k, v in var.deployment_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      alarm_ignore_poll_failure = v.alarm_ignore_poll_failure == null ? var.alarm_ignore_poll_failure_default : v.alarm_ignore_poll_failure
      alarm_metric_name_list    = v.alarm_metric_name_list == null ? var.alarm_metric_name_list_default : v.alarm_metric_name_list
      alarm_monitoring_enabled  = v.alarm_monitoring_enabled == null ? var.alarm_monitoring_enabled_default : v.alarm_monitoring_enabled
      alert_enabled             = v.alert_enabled == null ? var.alert_enabled_default : v.alert_enabled
      alert_target_path_map = {
        application_name = "$.detail.application"
        aws_region_name  = "$.detail.region"
        deployment_group = "$.detail.deploymentGroup"
        deployment_id    = "$.detail.deploymentId"
      }
      alert_target_template               = <<-EOT
      {
        "Message": "CodeDeploy deployment '<deployment_id>' failed for application <application_name>!",
        "Deployment": "https://<aws_region_name>.console.aws.amazon.com/codesuite/codedeploy/deployments/<deployment_id>",
        "Group": "https://<aws_region_name>.console.aws.amazon.com/codesuite/codedeploy/applications/<application_name>/deployment-groups/<deployment_group>"
      }
      EOT
      auto_rollback_enabled               = v.auto_rollback_enabled == null ? var.deployment_auto_rollback_enabled_default : v.auto_rollback_enabled
      auto_rollback_event_list            = v.auto_rollback_event_list == null ? var.deployment_auto_rollback_event_list_default : v.auto_rollback_event_list
      blue_green_terminate_on_success     = v.blue_green_terminate_on_success == null ? var.deployment_blue_green_terminate_on_success_default : v.blue_green_terminate_on_success
      blue_green_termination_wait_minutes = v.blue_green_termination_wait_minutes == null ? var.deployment_blue_green_termination_wait_minutes_default : v.blue_green_termination_wait_minutes
      blue_green_timeout_action           = v.blue_green_timeout_action == null ? var.deployment_blue_green_timeout_action_default : v.blue_green_timeout_action
      blue_green_timeout_wait_minutes     = v.blue_green_timeout_wait_minutes == null ? var.deployment_blue_green_timeout_wait_minutes_default : v.blue_green_timeout_wait_minutes
      deployment_app_key                  = v.deployment_app_key == null ? var.deployment_app_key_default == null ? k : var.deployment_app_key_default : v.deployment_app_key
      deployment_config_key               = v.deployment_config_key == null ? var.deployment_config_key_default == null ? k : var.deployment_config_key_default : v.deployment_config_key
      deployment_environment_map          = v.deployment_environment_map == null ? var.deployment_environment_map_default : v.deployment_environment_map
      deployment_style_use_load_balancer  = v.deployment_style_use_load_balancer == null ? var.deployment_style_use_load_balancer_default : v.deployment_style_use_load_balancer
      ecs_service_map = {
        for k_serv, v_serv in v.ecs_service_map : k_serv => merge(v_serv, {
          cluster_key = v_serv.cluster_key == null ? var.deployment_ecs_service_cluster_key_default : v_serv.cluster_key
        })
      }
      green_fleet_provisioning_enabled = false # TODO: Not supported for ECS
      iam_role_arn                     = var.ci_cd_account_data.role.deploy.ecs.iam_role_arn
      trigger_map                      = v.trigger_map == null ? var.deployment_trigger_map_default : v.trigger_map
      update_new_instances             = v.update_new_instances == null ? var.deployment_update_new_instances_default : v.update_new_instances
    })
  }
  l2_map = {
    for k, _ in local.l0_map : k => {
      alert_event_pattern_json = jsonencode({
        detail = {
          deploymentGroup = [
            local.l1_map[k].name_effective
          ]
          state = [
            "FAILURE"
          ]
        }
        detail-type = [
          "CodeDeploy Deployment State-change Notification",
        ]
        source = [
          "aws.codedeploy",
        ]
      })
      blue_green_timeout_wait_minutes_effective = local.l1_map[k].blue_green_timeout_action == "STOP_DEPLOYMENT" ? local.l1_map[k].blue_green_timeout_wait_minutes : 0
      deployment_app_name                       = var.deployment_app_data_map[local.l1_map[k].deployment_app_key].name_effective
      deployment_config_name                    = var.deployment_config_data_map[local.l1_map[k].deployment_config_key].name_effective
      deployment_style_use_blue_green           = lookup(local.l1_map[k].deployment_environment_map, "green", null) != null
      ecs_service_map = {
        for k_serv, v_serv in local.l1_map[k].ecs_service_map : k_serv => merge(v_serv, {
          auto_scaling_group_arn = var.ecs_cluster_data_map[v_serv.cluster_key].auto_scaling_group.auto_scaling_group_arn
          cluster_name           = v_serv.cluster_key == null ? null : var.ecs_cluster_data_map[v_serv.cluster_key].name_effective
          service_name           = var.ecs_service_data_map[k_serv].name_effective
        })
      }
      deployment_environment_map = {
        for k_env, v_env in local.l1_map[k].deployment_environment_map : k_env => v_env == null ? null : merge(v_env, {
          elb_listener_key     = v_env.elb_listener_key == null ? "${k}_${k_env}" : v_env.elb_listener_key
          elb_target_group_key = v_env.elb_target_group_key == null ? "${k}_${k_env}" : v_env.elb_target_group_key
        })
      }
      trigger_map = {
        for k_trig, v_trig in local.l1_map[k].trigger_map : k_trig => merge(v_trig, {
          event_list    = v_trig.event_list == null ? var.deployment_trigger_event_list_default : v_trig.event_list
          sns_topic_arn = v_trig.sns_topic_arn == null ? var.deployment_trigger_sns_topic_arn_default : v_trig.sns_topic_arn
        })
      }
    }
  }
  l3_map = {
    for k, _ in local.l0_map : k => {
      auto_scaling_group_arn_list = [
        for k_serv, v_serv in local.l2_map[k].ecs_service_map : v_serv.auto_scaling_group_arn
      ]
      deployment_environment_map = {
        for k_env, v_env in local.l2_map[k].deployment_environment_map : k_env => v_env == null ? null : merge(v_env, {
          elb_listener_arn      = var.elb_listener_data_map[v_env.elb_listener_key].elb_listener_target_arn
          elb_target_group_name = var.elb_target_data_map[v_env.elb_target_group_key].target_group_name
        })
      }
    }
  }
  l4_map = {
    for k, _ in local.l0_map : k => {
      auto_scaling_group_arn_list_effective = [] # TODO: Not supported for ECS
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k], local.l4_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains(["alert_event_pattern_json"], k_attr)
      },
      {
        alert     = module.alert_trigger.data[k]
        group_arn = aws_codedeploy_deployment_group.this_group[k].arn
        group_id  = aws_codedeploy_deployment_group.this_group[k].id
      }
    )
  }
}
