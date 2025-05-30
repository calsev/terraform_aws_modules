locals {
  output_data = merge(module.managed_policies.data, {
    iam_instance_profile_arn_ecs     = module.ecs_instance_role.data.iam_instance_profile_arn
    iam_policy_arn_ecs_exec_ssm      = module.policy.data["ecs_exec"].iam_policy_arn
    iam_policy_arn_ecs_start_task    = module.policy.data["ecs_task_start"].iam_policy_arn
    iam_policy_doc_ecs_exec_ssm      = module.policy.data["ecs_exec"].iam_policy_doc
    iam_policy_doc_ecs_start_task    = module.policy.data["ecs_task_start"].iam_policy_doc
    iam_role_arn_ecs_instance        = module.ecs_instance_role.data.iam_role_arn
    iam_role_arn_ecs_task_execution  = module.ecs_task_execution_role.data.iam_role_arn
    iam_role_data_ecs_instance       = module.ecs_instance_role.data
    iam_role_data_ecs_task_execution = module.ecs_task_execution_role.data
  })
}
