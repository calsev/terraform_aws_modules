module "this_role" {
  source                   = "../../../../iam/role/base"
  assume_role_service_list = ["ecs-tasks"]
  embedded_role_policy_attach_arn_map = {
    ecs_task_execution = {
      policy = var.iam_data.iam_policy_arn_ecs_task_execution
    }
  }
  map_policy                           = var.map_policy
  max_session_duration_m               = var.max_session_duration_m
  name                                 = var.name
  {{ name.map_item() }}
  {{ iam.role_map_item() }}
  std_map                              = var.std_map
}
