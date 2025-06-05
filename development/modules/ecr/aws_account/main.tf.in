resource "aws_ecr_registry_scanning_configuration" "this_config" {
  dynamic "rule" {
    for_each = local.scan_rule_map
    content {
      dynamic "repository_filter" {
        for_each = rule.value.repository_filter_map
        content {
          filter      = repository_filter.value.filter
          filter_type = repository_filter.value.filter_type
        }
      }
      scan_frequency = rule.value.scan_frequency
    }
  }
  scan_type = var.scan_type
}
