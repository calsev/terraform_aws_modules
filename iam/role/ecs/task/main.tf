module "this_role" {
  source                   = "../../../../iam/role/base"
  assume_role_service_list = ["ecs-tasks"]
  embedded_role_policy_attach_arn_map = {
    exec_ssm = {
      condition = var.ecs_exec_enabled
      policy    = var.ecs_exec_enabled ? var.iam_data.iam_policy_arn_ecs_exec_ssm : null
    }
    log_write = {
      policy = var.log_data.iam_policy_arn_map.write
    }
  }
  map_policy                           = var.map_policy
  max_session_duration_m               = var.max_session_duration_m
  name                                 = var.name
  name_prefix                          = var.name_prefix
  name_infix                           = var.name_infix
  role_policy_attach_arn_map_default   = var.role_policy_attach_arn_map_default
  role_policy_create_json_map_default  = var.role_policy_create_json_map_default
  role_policy_inline_json_map_default  = var.role_policy_inline_json_map_default
  role_policy_managed_name_map_default = var.role_policy_managed_name_map_default
  role_path                            = var.role_path
  std_map                              = var.std_map
}
