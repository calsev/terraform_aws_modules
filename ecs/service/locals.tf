module "name_map" {
  source                          = "../../name_map"
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  std_map                         = var.std_map
}

module "vpc_map" {
  source                              = "../../vpc/id_map"
  vpc_map                             = var.service_map
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_key_default                     = var.vpc_key_default
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
  vpc_segment_key_default             = var.vpc_segment_key_default
  vpc_data_map                        = var.vpc_data_map
}

locals {
  create_sd_map = {
    for k, v in local.lx_map : k => v if v.sd_hostname != null
  }
  l0_map = {
    for k, v in var.service_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      alarm_metric_name_list                         = v.alarm_metric_name_list == null ? var.alarm_metric_name_list_default : v.alarm_metric_name_list
      alarm_monitoring_enabled                       = v.alarm_monitoring_enabled == null ? var.alarm_monitoring_enabled_default : v.alarm_monitoring_enabled
      alarm_rollback_enabled                         = v.alarm_rollback_enabled == null ? var.alarm_rollback_enabled_default : v.alarm_rollback_enabled
      desired_count                                  = v.desired_count == null ? var.service_desired_count_default : v.desired_count
      deployment_controller_circuit_breaker_enabled  = v.deployment_controller_circuit_breaker_enabled == null ? var.service_deployment_controller_circuit_breaker_enabled_default : v.deployment_controller_circuit_breaker_enabled
      deployment_controller_circuit_breaker_rollback = v.deployment_controller_circuit_breaker_rollback == null ? var.service_deployment_controller_circuit_breaker_rollback_default : v.deployment_controller_circuit_breaker_rollback
      deployment_controller_type                     = v.deployment_controller_type == null ? var.service_deployment_controller_type_default : v.deployment_controller_type
      deployment_maximum_percent                     = v.deployment_maximum_percent == null ? var.service_deployment_maximum_percent_default : v.deployment_maximum_percent
      deployment_minimum_healthy_percent             = v.deployment_minimum_healthy_percent == null ? var.service_deployment_minimum_healthy_percent_default : v.deployment_minimum_healthy_percent
      ecs_cluster_key                                = v.ecs_cluster_key == null ? var.service_ecs_cluster_key_default == null ? k : var.service_ecs_cluster_key_default : v.ecs_cluster_key
      ecs_task_definition_key                        = v.ecs_task_definition_key == null ? var.service_ecs_task_definition_key_default == null ? k : var.service_ecs_task_definition_key_default : v.ecs_task_definition_key
      elb_health_check_grace_period_seconds          = v.elb_health_check_grace_period_seconds == null ? var.service_elb_health_check_grace_period_seconds_default : v.elb_health_check_grace_period_seconds
      elb_target_map                                 = v.elb_target_map == null ? var.service_elb_target_map_default : v.elb_target_map
      execute_command_enabled                        = v.execute_command_enabled == null ? var.service_execute_command_enabled_default : v.execute_command_enabled
      force_new_deployment                           = v.force_new_deployment == null ? var.service_force_new_deployment_default : v.force_new_deployment
      iam_role_arn_elb_calls                         = v.iam_role_arn_elb_calls == null ? var.service_iam_role_arn_elb_calls_default : v.iam_role_arn_elb_calls
      managed_tags_enabled                           = v.managed_tags_enabled == null ? var.service_managed_tags_enabled_default : v.managed_tags_enabled
      propagate_tag_source                           = v.propagate_tag_source == null ? var.service_propagate_tag_source_default : v.propagate_tag_source
      scheduling_strategy                            = v.scheduling_strategy == null ? var.service_scheduling_strategy_default : v.scheduling_strategy
      sd_namespace_key                               = v.sd_namespace_key == null ? var.service_sd_namespace_key_default : v.sd_namespace_key
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      assign_public_ip                                         = var.ecs_cluster_data[local.l1_map[k].ecs_cluster_key].capability_type == "EC2" ? false : v.assign_public_ip == null ? var.service_assign_public_ip_default == null ? local.l1_map[k].vpc_segment_route_public : var.service_assign_public_ip_default : v.assign_public_ip
      capacity_provider_name                                   = var.ecs_cluster_data[local.l1_map[k].ecs_cluster_key].capacity_provider_name
      deployment_controller_circuit_breaker_enabled_effective  = local.l1_map[k].deployment_controller_type == "ECS" ? local.l1_map[k].deployment_controller_circuit_breaker_enabled : null
      deployment_controller_circuit_breaker_rollback_effective = local.l1_map[k].deployment_controller_type == "ECS" ? local.l1_map[k].deployment_controller_circuit_breaker_rollback : null
      deployment_maximum_percent_effective                     = local.l1_map[k].scheduling_strategy == "DAEMON" ? null : local.l1_map[k].deployment_maximum_percent
      deployment_minimum_healthy_percent_effective             = local.l1_map[k].scheduling_strategy == "DAEMON" ? null : local.l1_map[k].deployment_minimum_healthy_percent
      desired_count_effective                                  = local.l1_map[k].scheduling_strategy == "DAEMON" ? null : local.l1_map[k].desired_count
      ecs_cluster_id                                           = var.ecs_cluster_data[local.l1_map[k].ecs_cluster_key].ecs_cluster_id
      ecs_task_definition_arn                                  = var.ecs_task_definition_data_map[local.l1_map[k].ecs_task_definition_key].task_definition_arn_latest_rev
      elb_target_map = {
        for k_targ, v_targ in local.l1_map[k].elb_target_map : k_targ => merge(v_targ, {
          container_name   = v_targ.container_name == null ? var.service_elb_target_container_name_default == null ? length(v.container_definition_map) == 1 ? keys(v.container_definition_map)[0] : null : var.service_elb_target_container_name_default : v_targ.container_name
          container_port   = v_targ.container_port == null ? var.service_elb_target_container_port_default : v_targ.container_port
          target_group_arn = var.elb_target_data_map[k_targ].target_group_arn
        })
      }
      force_new_deployment_effective = local.l1_map[k].deployment_controller_type == "ECS" ? local.l1_map[k].force_new_deployment : false
      is_attached_to_elb             = length(local.l1_map[k].elb_target_map) != 0
      network_mode                   = var.ecs_task_definition_data_map[local.l1_map[k].ecs_task_definition_key].network_mode
      placement_constraint_list = var.ecs_cluster_data[local.l1_map[k].ecs_cluster_key].capability_type == "FARGATE" ? [] : [
        {
          field = "attribute:ecs.availability-zone"
          type  = "spread"
        },
        {
          field = "instanceId"
          type  = "spread"
        },
      ]
      sd_namespace_id = v.sd_hostname == null ? null : var.dns_data.domain_to_sd_zone_map[local.l1_map[k].sd_namespace_key].id
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      elb_health_check_grace_period_seconds_effective = local.l2_map[k].is_attached_to_elb ? local.l1_map[k].elb_health_check_grace_period_seconds : null
      iam_role_arn_elb_calls_effective                = local.l2_map[k].network_mode == "awsvpc" ? null : local.l1_map[k].iam_role_arn_elb_calls
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
        dns_name     = v.sd_hostname == null ? null : "${v.sd_hostname}.${v.sd_namespace_key}"
        service_name = aws_ecs_service.this_service[k].name
      }
    )
  }
}
