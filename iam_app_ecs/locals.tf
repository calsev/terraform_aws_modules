locals {
  output_data = merge(module.managed_policies.data, {
    iam_instance_profile_arn_ecs    = module.ecs_instance_role.data.iam_instance_profile_arn
    iam_policy_arn_ecs_start_task   = module.ecs_start_task_policy.iam_policy_arn
    iam_role_arn_ecs_instance       = module.ecs_instance_role.data.iam_role_arn
    iam_role_arn_ecs_start_task     = module.ecs_start_task_role.data.iam_role_arn
    iam_role_arn_ecs_task_execution = data.aws_iam_role.ecs_task_execution_role.arn
  })
}