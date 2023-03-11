resource "aws_ecs_service" "this_service" {
  capacity_provider_strategy {
    base              = var.desired_count
    capacity_provider = var.capacity_provider_name
    weight            = 100
  }
  cluster = var.ecs_cluster_id
  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }
  deployment_controller {
    type = "ECS"
  }
  desired_count                     = var.desired_count
  enable_ecs_managed_tags           = true
  enable_execute_command            = true
  health_check_grace_period_seconds = 0
  name                              = local.resource_name
  network_configuration {
    assign_public_ip = var.assign_public_ip
    subnets          = local.vpc_subnet_id_list
    security_groups  = local.vpc_security_group_id_list
  }
  ordered_placement_strategy {
    field = "attribute:ecs.availability-zone"
    type  = "spread"
  }
  ordered_placement_strategy {
    field = "instanceId"
    type  = "spread"
  }
  propagate_tags = "SERVICE"
  dynamic "service_registries" {
    for_each = var.public_dns_name != null ? { this = {} } : {}
    content {
      registry_arn = aws_service_discovery_service.discovery["this"].arn
    }
  }
  task_definition = var.ecs_task_definition_arn
}
