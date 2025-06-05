resource "aws_codestarconnections_host" "this_host" {
  for_each          = local.lx_map
  name              = each.value.name_override == null ? each.value.name_effective : each.value.name_override
  provider_endpoint = each.value.provider_endpoint
  provider_type     = each.value.provider_type
  dynamic "vpc_configuration" {
    for_each = each.value.vpc_key == null ? {} : { this = {} }
    content {
      security_group_ids = each.value.vpc_security_group_id_list
      subnet_ids         = each.value.vpc_subnet_id_list
      tls_certificate    = each.value.tls_certificate
      vpc_id             = each.value.vpc_id
    }
  }
}
