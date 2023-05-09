locals {
  output_data = merge(module.managed_policies.data, {
    iam_instance_profile_arn_ecs     = module.ecs_instance_role.data.iam_instance_profile_arn
    iam_policy_arn_ecs_start_task    = module.ecs_start_task_policy.iam_policy_arn
    iam_policy_doc_ecs_start_task    = jsondecode(data.aws_iam_policy_document.ecs_start_task_policy.json)
    iam_role_arn_ecs_instance        = module.ecs_instance_role.data.iam_role_arn
    iam_role_arn_ecs_task_execution  = module.ecs_task_execution_role.data.iam_role_arn
    iam_role_data_ecs_instance       = module.ecs_instance_role.data
    iam_role_data_ecs_task_execution = module.ecs_task_execution_role.data
  })
}
