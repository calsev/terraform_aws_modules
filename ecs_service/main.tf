module "vpc_map" {
  source                              = "../vpc_id_map"
  vpc_map                             = var.service_map
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_key_default                     = var.vpc_key_default
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
  vpc_segment_key_default             = var.vpc_segment_key_default
  vpc_data_map                        = var.vpc_data_map
}

resource "aws_ecs_service" "this_service" {
  for_each = local.service_map
  capacity_provider_strategy {
    base              = each.value.desired_count
    capacity_provider = each.value.capacity_provider_name
    weight            = 100
  }
  cluster = each.value.ecs_cluster_id
  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }
  deployment_controller {
    type = "ECS"
  }
  desired_count                     = each.value.desired_count
  enable_ecs_managed_tags           = true
  enable_execute_command            = true
  health_check_grace_period_seconds = 0
  name                              = each.value.name_effective
  network_configuration {
    assign_public_ip = each.value.assign_public_ip
    subnets          = each.value.vpc_subnet_id_list
    security_groups  = each.value.vpc_security_group_id_list
  }
  dynamic "ordered_placement_strategy" {
    for_each = each.value.placement_constraint_list
    content {
      field = ordered_placement_strategy.value.field
      type  = ordered_placement_strategy.value.type
    }
  }
  propagate_tags = "SERVICE"
  dynamic "service_registries" {
    for_each = each.value.sd_hostname != null ? { this = {} } : {}
    content {
      container_name = each.value.sd_container_name
      container_port = each.value.sd_container_port
      port           = each.value.sd_port
      registry_arn   = aws_service_discovery_service.discovery[each.key].arn
    }
  }
  task_definition = each.value.ecs_task_definition_arn
}
