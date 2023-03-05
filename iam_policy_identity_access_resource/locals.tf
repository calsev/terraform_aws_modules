locals {
  sid_map = {
    for access in var.access_list : access => {
      for resource_type, resource_name_list in var.resource_map : resource_type => {
        resource_list = resource_name_list
        sid           = "${local.pascal_map[resource_type]}${var.std_map.access_title_map[access]}"
      }
    }
  }
  pascal_map = {
    for resource_type, _ in var.resource_map : resource_type => join("", [for part in split("_", resource_type) : title(part)])
  }
}
