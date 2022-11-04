output "iam_role_arn_ecs_task" {
  value = module.ecs_task_role.data.iam_role_arn
}

output "task_definition_arn_latest" {
  value = local.task_definition_arn_latest
}

output "test_definition_arn_latest_rev" {
  value = aws_ecs_task_definition.this_task.arn
}
