resource "aws_sfn_state_machine" "this_machine" {
  for_each   = local.machine_map
  definition = each.value.definition_json
  logging_configuration {
    include_execution_data = true
    level                  = each.value.log_level
    log_destination        = "${each.value.log_data.log_group_arn}:*"
  }
  name     = each.value.name
  role_arn = each.value.iam_role_arn
  tags     = each.value.tags
  tracing_configuration {
    enabled = true
  }
}
