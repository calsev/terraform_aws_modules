resource "aws_ecs_capacity_provider" "this_capacity_provider" {
  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.this_asg.arn
    managed_scaling {
      instance_warmup_period    = 300
      maximum_scaling_step_size = 1
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
    managed_termination_protection = "ENABLED"
  }
  name = local.resource_name
  tags = local.tags
}

#resource "aws_kms_key" "this_kms_key" {
#  description             = local.resource_name
#  deletion_window_in_days = 7
#  tags                    = local.tags
#}

resource "aws_cloudwatch_log_group" "this_log_group" {
  name_prefix       = local.resource_name_prefix
  retention_in_days = 7
  tags              = local.tags
}

resource "aws_ecs_cluster" "this_ecs_cluster" {
  configuration {
    execute_command_configuration {
      #      kms_key_id = aws_kms_key.this_kms_key.arn
      log_configuration {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.this_log_group.name
      }
      logging = "OVERRIDE"
    }
  }
  name = local.resource_name
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = local.tags
}

resource "aws_ecs_cluster_capacity_providers" "this_capacity_provider" {
  capacity_providers = [
    aws_ecs_capacity_provider.this_capacity_provider.name
  ]
  cluster_name = aws_ecs_cluster.this_ecs_cluster.name
  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.this_capacity_provider.name
    weight            = 100
  }
}
