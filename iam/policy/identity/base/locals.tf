locals {
  name_context          = var.name == null ? null : "${var.std_map.resource_name_prefix}${replace(var.name, var.std_map.name_replace_regex, "-")}${var.std_map.resource_name_suffix}"
  name_prefix           = local.name_prefix_sanitized == "" ? "" : replace("${local.name_prefix_sanitized}-", "--", "-")
  name_prefix_sanitized = replace(var.name_prefix, var.std_map.name_replace_regex, "-")
  policy_name           = var.name == null ? null : var.name_infix ? "${local.name_prefix}${local.name_context}" : "${local.name_prefix}${var.name}"
  tags = var.name == null ? null : merge(
    var.std_map.tags,
    {
      Name = local.name_context
    }
  )
}
