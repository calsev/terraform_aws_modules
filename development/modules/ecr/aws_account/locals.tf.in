locals {
  scan_rule_map = {
    for k, v in var.scan_rule_map : k => merge(v, {
      repository_filter_map = {
        for k_filter, v_filter in v.repository_filter_map : k_filter => merge(v_filter, {
          filter      = v_filter.filter == null ? var.scan_rule_filter_default : v_filter.filter
          filter_type = v_filter.filter_type == null ? var.scan_rule_filter_type_default : v_filter.filter_type
        })
      }
      scan_frequency = v.scan_frequency == null ? var.scan_rule_scan_frequency_default : v.scan_frequency
    })
  }
  output_data = {
    scan_rule_map = local.scan_rule_map
    scan_type     = var.scan_type
  }
}
