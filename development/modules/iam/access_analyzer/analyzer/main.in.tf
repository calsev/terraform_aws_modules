resource "aws_accessanalyzer_analyzer" "this" {
  for_each      = local.lx_map
  analyzer_name = each.value.name_effective
  dynamic "configuration" {
    for_each = each.value.has_configuration ? { this = {} } : {}
    content {
      unused_access {
        unused_access_age = each.value.unused_access_age
      }
    }
  }
  tags = each.value.tags
  type = each.value.analyzer_type
}
