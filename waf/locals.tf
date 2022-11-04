locals {
  tags = merge(
    var.std_map.tags,
    {
      Name = "${var.std_map.resource_name_prefix}${lower(var.name)}${var.std_map.resource_name_suffix}"
    }
  )
}
