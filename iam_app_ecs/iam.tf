data "aws_iam_policy_document" "read_ssm_cw_config" {
  statement {
    actions = [
      "ssm:GetParameter"
    ]
    resources = [
      "arn:aws:ssm:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:parameter/*cloudwatch-agent-config*",
      "arn:aws:ssm:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:parameter/*cloud-watch-agent-config*",
    ]
  }
}

module "read_ssm_cw_config_policy" {
  source          = "../iam_policy_identity"
  iam_policy_json = data.aws_iam_policy_document.read_ssm_cw_config.json
  name            = "read_ssm_cw_config_for_ecs"
  name_prefix     = var.name_prefix
  std_map         = var.std_map
}

module "ecs_instance_role" {
  source = "../iam_role_ecs_instance"
  attach_policy_arn_map = {
    read_ssm_cw_config = module.read_ssm_cw_config_policy.iam_policy_arn
  }
  name_prefix = var.name_prefix
  std_map     = var.std_map
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

data "aws_iam_policy_document" "ecs_start_task_policy" {
  statement {
    actions = [
      "ecs:RunTask",
    ]
    resources = ["arn:aws:ecs:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:task-definition/*"]
  }
  statement {
    actions = [
      "iam:PassRole",
    ]
    resources = [data.aws_iam_role.ecs_task_execution_role.arn]
  }
}

module "ecs_start_task_policy" {
  source          = "../iam_policy_identity"
  iam_policy_json = data.aws_iam_policy_document.ecs_start_task_policy.json
  name            = "ecs_task_start"
  name_prefix     = var.name_prefix
  std_map         = var.std_map
}

module "ecs_start_task_role" {
  source                   = "../iam_role"
  assume_role_service_list = var.std_map.task_starter_service_list
  attach_policy_arn_map = {
    ecs_start_task = module.ecs_start_task_policy.iam_policy_arn
  }
  name        = "ecs_task_start"
  name_prefix = var.name_prefix
  std_map     = var.std_map
}
