locals {
  resource_name = "${var.std_map.resource_name_prefix}${replace(var.name, "_", "-")}${var.std_map.resource_name_suffix}"
  tags = merge(
    var.std_map.tags,
    {
      Name = local.resource_name
    }
  )
}
