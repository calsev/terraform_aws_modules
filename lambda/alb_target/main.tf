module "target_group" {
  source              = "../../elb/target_group"
  std_map             = var.std_map
  target_map          = local.lx_map
  target_type_default = "lambda"
  vpc_data_map        = var.vpc_data_map
  vpc_key_default     = var.vpc_key_default
}

module "listener" {
  source                                = "../../elb/listener"
  dns_data                              = var.dns_data
  elb_data_map                          = var.elb_data_map
  elb_target_data_map                   = module.target_group.data
  listener_acm_certificate_key_default  = var.listener_acm_certificate_key_default
  listener_action_order_default         = var.listener_action_order_default
  listener_dns_from_zone_key_default    = var.listener_dns_from_zone_key_default
  listener_elb_key_default              = var.listener_elb_key_default
  listener_map                          = local.lx_map
  rule_condition_map_default            = var.rule_condition_map_default
  rule_host_header_pattern_list_default = var.rule_host_header_pattern_list_default
  rule_http_header_map_default          = var.rule_http_header_map_default
  rule_http_request_method_list_default = var.rule_http_request_method_list_default
  rule_path_pattern_list_default        = var.rule_path_pattern_list_default
  rule_query_string_map_default         = var.rule_query_string_map_default
  rule_source_ip_list_default           = var.rule_source_ip_list_default
  std_map                               = var.std_map
}

module "lambda_permission" {
  source                       = "../../lambda/permission"
  name_prepend_default         = var.target_lambda_permission_name_prepend_default
  permission_map               = local.create_lambda_permission_map
  permission_principal_default = "elasticloadbalancing.amazonaws.com"
  std_map                      = var.std_map
}

resource "aws_lb_target_group_attachment" "this_attachment" {
  for_each          = local.create_lambda_permission_map
  depends_on        = [module.lambda_permission] # Fails first time without this
  availability_zone = null
  port              = null
  target_group_arn  = each.value.source_arn
  target_id         = each.value.lambda_arn
}
