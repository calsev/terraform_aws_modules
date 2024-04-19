locals {
  sid_map = {
    for access in var.access_list : access => {
      for resource_type, resource_name_list in var.resource_map : resource_type => {
        resource_list = resource_name_list
        sid           = "${local.pascal_map[resource_type]}${var.std_map.access_title_map[access]}"
      } if length(var.std_map.service_resource_access_action[var.service_name][resource_type][access]) > 0 && length(resource_name_list) > 0
    }
  }
  pascal_map = {
    for resource_type, _ in var.resource_map : resource_type => join("", [for part in split("-", replace(resource_type, var.std_map.name_replace_regex, "-")) : title(part)])
  }
}
