module "this_role" {
  source                   = "../../../../iam/role/base"
  assume_role_service_list = ["ecs-tasks"]
  embedded_role_policy_attach_arn_map = {
    exec_ssm = {
      condition = var.ecs_exec_enabled
      policy    = var.ecs_exec_enabled ? var.iam_data.iam_policy_arn_ecs_exec_ssm : null
    }
    log_write = {
      policy = var.log_data.policy_map["write"].iam_policy_arn
    }
  }
  map_policy                           = var.map_policy
  max_session_duration_m               = var.max_session_duration_m
  name                                 = var.name
  {{ name.map_item() }}
  {{ iam.role_map_item() }}
  std_map                              = var.std_map
}
