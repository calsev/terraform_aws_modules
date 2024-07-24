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
  source = "../../../iam/role/ecs/task_execution"
  iam_data = {
    iam_policy_arn_ecs_task_execution = module.managed_policies.data.iam_policy_arn_ecs_task_execution
  }
  name        = "ecs_task_execution"
  name_prefix = var.name_prefix
  std_map     = var.std_map
}

data "aws_iam_policy_document" "ecs_exec_ssm_policy" {
  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
    ]
    resources = ["*"] # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-iam-roles.html#ecs-exec-required-iam-permissions
  }
}

module "ecs_exec_ssm_policy" {
  source          = "../../../iam/policy/identity/base"
  iam_policy_json = data.aws_iam_policy_document.ecs_exec_ssm_policy.json
  name            = "ecs_exec"
  name_prefix     = var.name_prefix
  std_map         = var.std_map
}

data "aws_iam_policy_document" "ecs_start_task_policy" {
  statement {
    actions = [
      "ecs:RunTask",
    ]
    # This seems a bit loose, but the managed policy for batch is analogous
    resources = ["arn:${var.std_map.iam_partition}:ecs:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:task-definition/*"]
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
