module "ecr_repo" {
  source = "../../ecr/repo"
  repo_map = {
    (var.ecr_repo_name) = {}
  }
  std_map = var.std_map
}

module "computation" {
  source = "../../ecs/compute"
  compute_map = {
    (var.task_name) = {
      instance_type = var.instance_type
      min_instances = var.min_instances
    }
  }
  monitor_data                        = var.monitor_data
  iam_data                            = var.iam_data
  std_map                             = var.std_map
  vpc_az_key_list_default             = var.vpc_az_key_list
  vpc_data_map                        = var.vpc_data_map
  vpc_key_default                     = var.vpc_key
  vpc_security_group_key_list_default = var.vpc_security_group_key_list
  vpc_segment_key_default             = var.vpc_segment_key
}

module "ecr_mirror_log" {
  source = "../../cw/log_group"
  log_map = {
    (var.task_name) = {}
  }
  std_map = var.std_map
}

module "ecr_mirror_task" {
  source           = "../../ecs/task"
  ecs_cluster_data = module.computation.data
  iam_data         = var.iam_data
  monitor_data     = var.monitor_data
  std_map          = var.std_map
  task_map = {
    (var.task_name) = {
      container_definition_list = local.mirror_container_definition_list
      schedule_expression       = var.schedule_expression
      ecs_cluster_arn           = module.computation.data[var.task_name].ecs_cluster_arn
      iam_role_arn_task         = module.ecs_task_role.data.iam_role_arn
      log_group_name            = module.ecr_mirror_log.data[var.task_name].log_group_name
    }
  }
}

module "task_trigger" {
  source = "../../event/trigger/base"
  event_map = {
    (var.task_name) = {
      definition_arn = module.ecr_mirror_task.data[var.task_name].task_definition_arn_latest
      target_arn     = module.computation.data[var.task_name].ecs_cluster_arn
    }
  }
  event_schedule_expression_default   = var.schedule_expression
  event_target_service_default        = "ecs"
  iam_data                            = var.iam_data
  std_map                             = var.std_map
  vpc_az_key_list_default             = var.vpc_az_key_list
  vpc_data_map                        = var.vpc_data_map
  vpc_key_default                     = var.vpc_key
  vpc_security_group_key_list_default = var.vpc_security_group_key_list
  vpc_segment_key_default             = var.vpc_segment_key
}
