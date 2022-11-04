module "this_policy" {
  source         = "../iam_policy_role_log_group"
  log_group_name = aws_cloudwatch_log_group.this_log_group.name
  name           = var.create_policy ? var.policy_name == null ? "${var.name}-log" : var.policy_name : null
  name_infix     = var.policy_name_infix
  name_prefix    = var.policy_name_prefix
  std_map        = var.std_map
}
