locals {
  name_context          = local.name_sanitized == null ? null : "${var.std_map.resource_name_prefix}${local.name_sanitized}${var.std_map.resource_name_suffix}"
  name_prefix_sanitized = lower(replace(replace(var.name_prefix, var.std_map.name_replace_regex, "-"), "--", "-"))
  name_sanitized        = var.name == null ? null : lower(replace(replace(var.name, var.std_map.name_replace_regex, "-"), "--", "-"))
  name_suffix_sanitized = lower(replace(replace(var.name_suffix, var.std_map.name_replace_regex, "-"), "--", "-"))
  policy_name           = local.name_sanitized == null ? null : var.name_infix ? "${local.name_prefix_sanitized}${local.name_context}${local.name_suffix_sanitized}" : "${local.name_prefix_sanitized}${local.name_sanitized}${local.name_suffix_sanitized}"
  tags = local.name_sanitized == null ? null : merge(
    var.std_map.tags,
    {
      Name = local.name_context
    }
  )
}
