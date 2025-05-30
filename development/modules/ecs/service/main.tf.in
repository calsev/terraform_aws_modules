resource "aws_ecs_service" "this_static_service" {
  for_each = local.create_deploy_ecs_map
  dynamic "alarms" {
    for_each = length(each.value.alarm_metric_name_list) == 0 ? {} : { this = {} }
    content {
      alarm_names = each.value.alarm_metric_name_list
      enable      = each.value.alarm_monitoring_enabled
      rollback    = alarms.alarm_rollback_enabled
    }
  }
  capacity_provider_strategy { # Conflicts with launch_type
    base              = 0      # Base does not work well with auto scaling and app spec
    capacity_provider = each.value.capacity_provider_name
    weight            = 100 # We are always using 1 ASG per cluster
  }
  cluster = each.value.ecs_cluster_id
  dynamic "deployment_circuit_breaker" {
    for_each = each.value.deployment_controller_type == "ECS" ? { this = {} } : {}
    content {
      enable   = each.value.deployment_controller_circuit_breaker_enabled_effective
      rollback = each.value.deployment_controller_circuit_breaker_rollback_effective
    }
  }
  deployment_controller {
    type = each.value.deployment_controller_type
  }
  deployment_maximum_percent         = each.value.deployment_maximum_percent_effective
  deployment_minimum_healthy_percent = each.value.deployment_minimum_healthy_percent_effective
  desired_count                      = each.value.desired_count_effective
  enable_ecs_managed_tags            = each.value.managed_tags_enabled
  enable_execute_command             = each.value.execute_command_enabled
  force_new_deployment               = each.value.force_new_deployment_effective
  health_check_grace_period_seconds  = each.value.elb_health_check_grace_period_seconds_effective
  iam_role                           = each.value.iam_role_arn_elb_calls_effective
  launch_type                        = null # Conflicts with capacity_provider_strategy
  dynamic "load_balancer" {
    for_each = each.value.elb_target_map
    content {
      elb_name         = null # ELB classic
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }
  }
  name = each.value.name_effective
  dynamic "network_configuration" {
    for_each = each.value.network_mode == "awsvpc" ? { this = {} } : {}
    content {
      assign_public_ip = each.value.assign_public_ip
      subnets          = each.value.vpc_subnet_id_list
      security_groups  = each.value.vpc_security_group_id_list
    }
  }
  dynamic "ordered_placement_strategy" {
    for_each = each.value.placement_constraint_list
    content {
      field = ordered_placement_strategy.value.field
      type  = ordered_placement_strategy.value.type
    }
  }
  platform_version = null # Fargate
  dynamic "placement_constraints" {
    for_each = {} # TODO
    content {
      expression = placement_constraints.value.type
      type       = placement_constraints.value.type
    }
  }
  propagate_tags      = each.value.propagate_tag_source
  scheduling_strategy = each.value.scheduling_strategy
  dynamic "service_connect_configuration" {
    for_each = {} # TODO
    content {
      enabled = service_connect_configuration.value.enabled
      log_configuration {
        log_driver = service_connect_configuration.value.log_driver
        options    = service_connect_configuration.value.option_list
        secret_option {
          name       = service_connect_configuration.value.secret_name
          value_from = service_connect_configuration.value.secret_arn
        }
      }
      namespace = service_connect_configuration.value.namespace
      dynamic "service" {
        for_each = service_connect_configuration.service_map
        content {
          dynamic "client_alias" {
            for_each = service.value.client_alias_port == null ? {} : { this = {} }
            content {
              dns_name = service.value.client_alias_fqdn
              port     = service.value.client_alias_port
            }
          }
          discovery_name        = service.value.discovery_name
          ingress_port_override = service.value.ingress_port_override
          port_name             = service.value.container_port_mapping_name
          dynamic "timeout" {
            for_each = service.value.timeout_map
            content {
              idle_timeout_seconds        = timeout.value.idle_timeout_seconds
              per_request_timeout_seconds = timeout.value.per_request_timeout_seconds
            }
          }
          tls {
            issuer_cert_authority {
              aws_pca_authority_arn = service.value.aws_pca_authority_arn
            }
            kms_key  = service.value.kms_key_name
            role_arn = service.value.iam_role_arn
          }
        }
      }
    }
  }
  dynamic "service_registries" {
    for_each = each.value.sd_hostname != null ? { this = {} } : {}
    content {
      container_name = each.value.sd_container_name
      container_port = each.value.sd_container_port
      port           = each.value.sd_port
      registry_arn   = aws_service_discovery_service.discovery[each.key].arn
    }
  }
  tags                  = each.value.tags
  task_definition       = each.value.ecs_task_definition_arn
  triggers              = {}    # TODO
  wait_for_steady_state = false # Terraform wait
}

resource "aws_ecs_service" "this_dynamic_service" {
  for_each = local.create_deploy_code_map
  dynamic "alarms" {
    for_each = length(each.value.alarm_metric_name_list) == 0 ? {} : { this = {} }
    content {
      alarm_names = each.value.alarm_metric_name_list
      enable      = each.value.alarm_monitoring_enabled
      rollback    = alarms.alarm_rollback_enabled
    }
  }
  capacity_provider_strategy { # Conflicts with launch_type
    base              = 0      # Base does not work well with auto scaling and app spec
    capacity_provider = each.value.capacity_provider_name
    weight            = 100 # We are always using 1 ASG per cluster
  }
  cluster = each.value.ecs_cluster_id
  dynamic "deployment_circuit_breaker" {
    for_each = each.value.deployment_controller_type == "ECS" ? { this = {} } : {}
    content {
      enable   = each.value.deployment_controller_circuit_breaker_enabled_effective
      rollback = each.value.deployment_controller_circuit_breaker_rollback_effective
    }
  }
  deployment_controller {
    type = each.value.deployment_controller_type
  }
  deployment_maximum_percent         = each.value.deployment_maximum_percent_effective
  deployment_minimum_healthy_percent = each.value.deployment_minimum_healthy_percent_effective
  desired_count                      = each.value.desired_count_effective
  enable_ecs_managed_tags            = each.value.managed_tags_enabled
  enable_execute_command             = each.value.execute_command_enabled
  force_new_deployment               = each.value.force_new_deployment_effective
  health_check_grace_period_seconds  = each.value.elb_health_check_grace_period_seconds_effective
  iam_role                           = each.value.iam_role_arn_elb_calls_effective
  launch_type                        = null # Conflicts with capacity_provider_strategy
  lifecycle {
    ignore_changes = [
      load_balancer, # TODO: Eye roll: https://github.com/hashicorp/terraform/issues/24188
      task_definition,
    ]
  }
  dynamic "load_balancer" {
    for_each = each.value.elb_target_map
    content {
      elb_name         = null # ELB classic
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }
  }
  name = each.value.name_effective
  dynamic "network_configuration" {
    for_each = each.value.network_mode == "awsvpc" ? { this = {} } : {}
    content {
      assign_public_ip = each.value.assign_public_ip
      subnets          = each.value.vpc_subnet_id_list
      security_groups  = each.value.vpc_security_group_id_list
    }
  }
  dynamic "ordered_placement_strategy" {
    for_each = each.value.placement_constraint_list
    content {
      field = ordered_placement_strategy.value.field
      type  = ordered_placement_strategy.value.type
    }
  }
  platform_version = null # Fargate
  dynamic "placement_constraints" {
    for_each = {} # TODO
    content {
      expression = placement_constraints.value.type
      type       = placement_constraints.value.type
    }
  }
  propagate_tags      = each.value.propagate_tag_source
  scheduling_strategy = each.value.scheduling_strategy
  dynamic "service_connect_configuration" {
    for_each = {} # TODO
    content {
      enabled = service_connect_configuration.value.enabled
      log_configuration {
        log_driver = service_connect_configuration.value.log_driver
        options    = service_connect_configuration.value.option_list
        secret_option {
          name       = service_connect_configuration.value.secret_name
          value_from = service_connect_configuration.value.secret_arn
        }
      }
      namespace = service_connect_configuration.value.namespace
      dynamic "service" {
        for_each = service_connect_configuration.service_map
        content {
          dynamic "client_alias" {
            for_each = service.value.client_alias_port == null ? {} : { this = {} }
            content {
              dns_name = service.value.client_alias_fqdn
              port     = service.value.client_alias_port
            }
          }
          discovery_name        = service.value.discovery_name
          ingress_port_override = service.value.ingress_port_override
          port_name             = service.value.container_port_mapping_name
          dynamic "timeout" {
            for_each = service.value.timeout_map
            content {
              idle_timeout_seconds        = timeout.value.idle_timeout_seconds
              per_request_timeout_seconds = timeout.value.per_request_timeout_seconds
            }
          }
          tls {
            issuer_cert_authority {
              aws_pca_authority_arn = service.value.aws_pca_authority_arn
            }
            kms_key  = service.value.kms_key_name
            role_arn = service.value.iam_role_arn
          }
        }
      }
    }
  }
  dynamic "service_registries" {
    for_each = each.value.sd_hostname != null ? { this = {} } : {}
    content {
      container_name = each.value.sd_container_name
      container_port = each.value.sd_container_port
      port           = each.value.sd_port
      registry_arn   = aws_service_discovery_service.discovery[each.key].arn
    }
  }
  tags                  = each.value.tags
  task_definition       = each.value.ecs_task_definition_arn
  triggers              = {}    # TODO
  wait_for_steady_state = false # Terraform wait
}

resource "aws_service_discovery_service" "discovery" {
  for_each = local.create_sd_map
  dns_config {
    dns_records {
      type = "A"
      ttl  = 300 # TODO: DRY with dns/record
    }
    namespace_id   = each.value.sd_namespace_id
    routing_policy = null
  }
  force_destroy = false
  # health_check_config # TODO
  # health_check_custom_config # TODO
  name         = each.value.sd_hostname
  namespace_id = each.value.sd_namespace_id
  tags         = each.value.tags
  type         = null
}
