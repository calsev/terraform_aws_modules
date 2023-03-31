module "vpc_map" {
  source                              = "../vpc_id_map"
  vpc_map                             = var.host_map
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_key_default                     = var.vpc_key_default
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
  vpc_segment_key_default             = var.vpc_segment_key_default
  vpc_data_map                        = var.vpc_data_map
}

resource "aws_codestarconnections_host" "this_host" {
  for_each          = local.host_map
  name              = each.value.name_override == null ? each.value.name_effective : each.value.name_override
  provider_endpoint = each.value.provider_endpoint
  provider_type     = each.value.provider_type == null ? var.connection_provider_type_default : each.value.provider_type
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

resource "aws_codestarconnections_connection" "this_codestar" {
  for_each      = local.connection_map
  host_arn      = each.value.host_key == null ? null : aws_codestarconnections_host.this_host[each.value.host_key].arn
  name          = each.value.name_effective
  provider_type = each.value.host_key == null ? each.value.provider_type : null
  tags          = each.value.tags
}
