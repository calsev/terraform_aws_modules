module "stage_log" {
  source  = "../../cw/log_group"
  log_map = local.stage_x_map
  std_map = var.std_map
}

resource "aws_apigatewayv2_stage" "this_stage" {
  for_each = local.stage_x_map
  access_log_settings {
    destination_arn = module.stage_log.data[each.key].log_group_arn
    format          = jsonencode(local.log_format_map)
  }
  api_id                = each.value.api_id
  auto_deploy           = false # This deploys in-flight changes; we basically auto-deploy after api change
  client_certificate_id = null  # For WebSocket only
  dynamic "default_route_settings" {
    for_each = each.value.enable_default_route ? { this = {} } : {}
    content {
      data_trace_enabled       = null # For WebSocket only
      detailed_metrics_enabled = each.value.detailed_metrics_enabled
      logging_level            = null # For WebSocket only
      throttling_burst_limit   = each.value.throttling_burst_limit
      throttling_rate_limit    = each.value.throttling_rate_limit
    }
  }
  deployment_id = each.value.deployment_id
  name          = each.value.name
  dynamic "route_settings" {
    for_each = each.value.route_map
    content {
      route_key                = route_settings.key
      data_trace_enabled       = null # For WebSocket only
      detailed_metrics_enabled = each.value.detailed_metrics_enabled
      logging_level            = null # For WebSocket only
      throttling_burst_limit   = each.value.throttling_burst_limit
      throttling_rate_limit    = each.value.throttling_rate_limit
    }
  }
  stage_variables = {} # TODO
  tags            = each.value.tags
}

resource "aws_apigatewayv2_api_mapping" "this_mapping" {
  for_each        = local.create_dns_mapping_map
  api_id          = each.value.api_id
  api_mapping_key = each.value.stage_path
  domain_name     = each.value.domain_id
  stage           = aws_apigatewayv2_stage.this_stage[each.key].id
}
