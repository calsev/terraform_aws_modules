module "log" {
  source  = "../cw/log_group"
  log_map = local.create_log_map
  std_map = var.std_map
}

resource "aws_sfn_state_machine" "this_machine" {
  for_each   = local.lx_map
  definition = each.value.definition_json
  logging_configuration {
    include_execution_data = true
    level                  = each.value.log_level
    log_destination        = "${module.log.data[each.key].log_group_arn}:*"
  }
  name     = each.value.name_effective
  role_arn = module.machine_role[each.key].data.iam_role_arn
  tags     = each.value.tags
  tracing_configuration {
    enabled = true
  }
}
