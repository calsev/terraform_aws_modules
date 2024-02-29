module "connection_policy" {
  for_each            = local.lx_map
  source              = "../../../iam/policy/identity/codestar/connection"
  connection_arn      = aws_codestarconnections_connection.this_codestar[each.key].arn
  connection_host_arn = aws_codestarconnections_connection.this_codestar[each.key].host_arn
  name                = var.policy_create ? var.policy_name == null ? "${each.key}_code_connection" : var.policy_name : null
  name_infix          = var.policy_name_infix
  name_prefix         = var.policy_name_prefix
  std_map             = var.std_map
}
