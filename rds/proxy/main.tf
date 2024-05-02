resource "aws_db_proxy" "this_proxy" {
  for_each = local.lx_map
  auth {
    auth_scheme               = "SECRETS"
    client_password_auth_type = each.value.auth_client_password_type
    iam_auth                  = each.value.auth_iam_required ? "REQUIRED" : "DISABLED"
    secret_arn                = each.value.auth_sm_secret_arn
    username                  = each.value.auth_username
  }
  debug_logging          = each.value.debug_logging_enabled
  engine_family          = each.value.engine_family
  idle_client_timeout    = each.value.idle_client_timeout_seconds
  name                   = each.value.name_effective
  require_tls            = each.value.tls_required
  role_arn               = each.value.iam_role_arn
  vpc_security_group_ids = each.value.vpc_security_group_id_list
  vpc_subnet_ids         = each.value.vpc_subnet_id_list
  tags                   = each.value.tags
}

resource "aws_db_proxy_default_target_group" "this_default_target" {
  # TODO: There is not a non-default target type yet
  for_each = local.create_target_group_x_map
  connection_pool_config {
    connection_borrow_timeout    = each.value.connection_borrow_timeout_seconds
    init_query                   = each.value.init_query
    max_connections_percent      = each.value.max_target_percent
    max_idle_connections_percent = each.value.max_idle_percent
    session_pinning_filters      = each.value.session_pinning_filter_list
  }
  db_proxy_name = aws_db_proxy.this_proxy[each.value.k_proxy].name
}

resource "aws_db_proxy_target" "this_target" {
  for_each               = local.create_target_x_map
  db_cluster_identifier  = null # TODO
  db_instance_identifier = each.value.db_name_effective
  db_proxy_name          = aws_db_proxy.this_proxy[each.value.k_proxy].name
  target_group_name      = aws_db_proxy_default_target_group.this_default_target[each.value.k_group_all].name
}
