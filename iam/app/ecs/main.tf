module "managed_policies" {
  source = "../../../iam/policy/managed"
  policy_map = {
    ecs_task_execution = "service-role/AmazonECSTaskExecutionRolePolicy"
  }
  std_map = var.std_map
}

module "ecs_instance_role" {
  source       = "../../../iam/role/ecs/instance"
  monitor_data = var.monitor_data
  name_prefix  = var.name_prefix
  std_map      = var.std_map
}

module "ecs_task_execution_role" {
  # ecsTaskExecutionRole does not exist in all accounts
  source                   = "../../../iam/role/base"
  assume_role_service_list = ["ecs-tasks"]
  name                     = "ecs_task_execution"
  name_prefix              = var.name_prefix
  role_policy_attach_arn_map_default = {
    ecs_task_execution = module.managed_policies.data.iam_policy_arn_ecs_task_execution
  }
  std_map = var.std_map
}

data "aws_iam_policy_document" "ecs_start_task_policy" {
  statement {
    actions = [
      "ecs:RunTask",
    ]
    # This seems a bit loose, but the managed policy for batch is analogous
    resources = ["arn:aws:ecs:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:task-definition/*"]
  }
  statement {
    actions = [
      "iam:PassRole",
    ]
    resources = [module.ecs_task_execution_role.data.iam_role_arn]
  }
}

module "ecs_start_task_policy" {
  source          = "../../../iam/policy/identity/base"
  iam_policy_json = data.aws_iam_policy_document.ecs_start_task_policy.json
  name            = "ecs_task_start"
  name_prefix     = var.name_prefix
  std_map         = var.std_map
}
