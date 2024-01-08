module "ecr_mirror_policy" {
  source      = "../iam/policy/identity/ecr"
  access_list = ["read_write"]
  name        = var.task_name
  repo_name   = "*"
  std_map     = var.std_map
}

module "ecs_task_role" {
  source   = "../iam/role/ecs_task"
  log_data = module.ecr_mirror_log.data[var.task_name]
  name     = var.task_name
  policy_attach_arn_map = {
    get_token        = var.iam_data.iam_policy_arn_ecr_get_token
    image_read_write = module.ecr_mirror_policy.data.iam_policy_arn_map.read_write
  }
  std_map = var.std_map
}
