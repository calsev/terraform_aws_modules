resource "aws_codestarconnections_host" "this_host" {
  for_each          = local.host_map
  name              = each.value.name_override == null ? each.value.resource_name : each.value.name_override
  provider_endpoint = each.value.provider_endpoint
  provider_type     = each.value.provider_type == null ? var.connection_provider_type_default : each.value.provider_type
  dynamic "vpc_configuration" {
    for_each = each.value.vpc_configuration == null ? {} : { this = each.value.vpc_configuration }
    content {
      security_group_ids = vpc_configuration.value.security_group_id_list
      subnet_ids         = vpc_configuration.value.subnet_id_list
      tls_certificate    = vpc_configuration.value.tls_certificate
      vpc_id             = vpc_configuration.value.vpc_id
    }
  }
}

resource "aws_codestarconnections_connection" "this_codestar" {
  for_each      = local.connection_map
  host_arn      = each.value.host_key == null ? null : aws_codestarconnections_host.this_host[each.value.host_key].arn
  name          = each.value.name
  provider_type = each.value.host_key == null ? each.value.provider_type : null
  tags          = each.value.tags
}
