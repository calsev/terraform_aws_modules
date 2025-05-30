resource "aws_codestarconnections_connection" "this_codestar" {
  for_each      = local.lx_map
  host_arn      = each.value.host_arn
  name          = each.value.name_override == null ? each.value.name_effective : each.value.name_override
  provider_type = each.value.host_key == null ? each.value.provider_type : null
  tags          = each.value.tags
}
