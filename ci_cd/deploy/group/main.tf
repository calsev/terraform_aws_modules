module "alert_trigger" {
  # This alert triggers on failure
  source                = "../../../event/alert"
  alert_enabled_default = var.alert_enabled_default
  alert_level_default   = var.alert_level_default
  alert_map             = local.lx_map
  monitor_data          = var.monitor_data
  name_append           = "deploy_failed"
  std_map               = var.std_map
}

resource "aws_codedeploy_deployment_group" "this_group" {
  for_each = local.lx_map
  dynamic "alarm_configuration" {
    # These are metric alarms that trigger failure
    for_each = length(each.value.alarm_metric_name_list) == 0 ? {} : { this = {} }
    content {
      alarms                    = each.value.alarm_metric_name_list
      enabled                   = each.value.alarm_monitoring_enabled
      ignore_poll_alarm_failure = alarms.alarm_ignore_poll_failure
    }
  }
  app_name = each.value.deployment_app_name
  auto_rollback_configuration {
    enabled = each.value.auto_rollback_enabled
    events  = each.value.auto_rollback_event_list
  }
  autoscaling_groups = each.value.auto_scaling_group_arn_list_effective
  dynamic "blue_green_deployment_config" {
    for_each = each.value.deployment_style_use_blue_green ? { this = {} } : {}
    content {
      deployment_ready_option {
        action_on_timeout    = each.value.blue_green_timeout_action
        wait_time_in_minutes = each.value.blue_green_timeout_wait_minutes_effective
      }
      dynamic "green_fleet_provisioning_option" {
        for_each = each.value.green_fleet_provisioning_enabled ? { this = {} } : {}
        content {
          action = "DISCOVER_EXISTING" # COPY_AUTO_SCALING_GROUP takes config out of TF
        }
      }
      terminate_blue_instances_on_deployment_success {
        action                           = each.value.blue_green_terminate_on_success ? "TERMINATE" : "KEEP_ALIVE"
        termination_wait_time_in_minutes = each.value.blue_green_termination_wait_minutes
      }
    }
  }
  deployment_config_name = each.value.deployment_config_name
  deployment_group_name  = each.value.name_effective
  deployment_style {
    deployment_option = each.value.deployment_style_use_load_balancer ? "WITH_TRAFFIC_CONTROL" : "WITHOUT_TRAFFIC_CONTROL"
    deployment_type   = each.value.deployment_style_use_blue_green ? "BLUE_GREEN" : "IN_PLACE"
  }
  # ec2_tag_filter # TODO
  # ec2_tag_set # TODO
  dynamic "ecs_service" {
    for_each = each.value.ecs_service_map
    content {
      cluster_name = ecs_service.value.cluster_name
      service_name = ecs_service.value.service_name
    }
  }
  dynamic "load_balancer_info" {
    for_each = each.value.deployment_style_use_load_balancer ? { this = {} } : {}
    content {
      # elb_info # For ELB classic
      dynamic "target_group_info" {
        for_each = each.value.deployment_style_use_blue_green ? {} : { this = {} }
        content {
          name = each.value.deployment_environment_map["blue"].elb_target_group_name
        }
      }
      dynamic "target_group_pair_info" {
        for_each = each.value.deployment_style_use_blue_green ? { this = {} } : {}
        content {
          prod_traffic_route {
            listener_arns = [each.value.deployment_environment_map["blue"].elb_listener_arn] # Must be one
          }
          dynamic "target_group" {
            for_each = each.value.deployment_environment_map
            content {
              name = target_group.value.elb_target_group_name
            }
          }
          dynamic "test_traffic_route" {
            for_each = each.value.deployment_environment_map["green"].elb_listener_arn == null ? {} : { this = {} }
            content {
              listener_arns = [each.value.deployment_environment_map["green"].elb_listener_arn] # Must be one
            }
          }
        }
      }
    }
  }
  # on_premises_instance_tag_filter
  outdated_instances_strategy = each.value.update_new_instances ? "UPDATE" : "IGNORE"
  service_role_arn            = each.value.iam_role_arn
  dynamic "trigger_configuration" {
    for_each = each.value.trigger_map
    content {
      trigger_events     = trigger_configuration.value.event_list
      trigger_name       = trigger_configuration.key
      trigger_target_arn = trigger_configuration.value.sns_topic_arn
    }
  }
  tags = each.value.tags
}
