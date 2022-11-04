module "ecs_task_role" {
  source                 = "../iam_role"
  assume_role_json       = var.std_map.assume_role_json.ecs_task
  attach_policy_arn_map  = local.task_role_iam_policy_arn_map
  inline_policy_json_map = local.task_role_iam_policy_json_map
  name                   = var.name
  std_map                = var.std_map
}
