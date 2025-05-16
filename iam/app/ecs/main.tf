module "managed_policies" {
  source = "../../../iam/policy/managed"
  policy_map = {
    ecs_task_execution = "service-role/AmazonECSTaskExecutionRolePolicy"
  }
  std_map = var.std_map
}

module "ecs_instance_role" {
  source                          = "../../../iam/role/ecs/instance"
  monitor_data                    = var.monitor_data
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

module "ecs_task_execution_role" {
  # ecsTaskExecutionRole does not exist in all accounts
  source = "../../../iam/role/ecs/task_execution"
  iam_data = {
    iam_policy_arn_ecs_task_execution = module.managed_policies.data.iam_policy_arn_ecs_task_execution
  }
  name                            = "ecs_task_execution"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
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

module "policy" {
  source                          = "../../../iam/policy/identity/base"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  policy_map = {
    ecs_exec = {
      iam_policy_json = data.aws_iam_policy_document.ecs_exec_ssm_policy.json
    }
    ecs_task_start = {
      iam_policy_json = data.aws_iam_policy_document.ecs_start_task_policy.json
    }
  }
  std_map = var.std_map
}
