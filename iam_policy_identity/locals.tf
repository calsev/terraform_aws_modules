locals {
  name_prefix           = local.name_prefix_sanitized == "" ? "" : replace("${local.name_prefix_sanitized}-", "--", "-")
  name_prefix_sanitized = replace(var.name_prefix, "/[._]/", "-")
  policy_name           = var.name == null ? null : var.name_infix ? "${local.name_prefix}${local.resource_name}" : "${local.name_prefix}${var.name}"
  resource_name         = var.name == null ? null : "${var.std_map.resource_name_prefix}${replace(var.name, "/[._]/", "-")}${var.std_map.resource_name_suffix}"
  tags = var.name == null ? null : merge(
    var.std_map.tags,
    {
      Name = local.resource_name
    }
  )
}
