locals {
  l1_map = {
    for k, v in var.name_map : k => merge(v, {
      name_infix  = v.name_infix == null ? var.name_infix_default : v.name_infix
      name_prefix = v.name_prefix == null ? var.name_prefix_default : v.name_prefix
      name_simple = replace(replace(k, var.name_regex, "-"), "--", "-")
    })
  }
  l2_map = {
    for k, _ in var.name_map : k => {
      name_context = "${local.l1_map[k].name_prefix}${var.std_map.resource_name_prefix}${replace(replace(k, var.resource_name_regex, "-"), "--", "-")}${var.std_map.resource_name_suffix}"
    }
  }
  l3_map = {
    for k, _ in var.name_map : k => {
      name_effective = local.l1_map[k].name_infix ? local.l2_map[k].name_context : "${local.l1_map[k].name_prefix}${local.l1_map[k].name_simple}"
      tags = merge(
        var.std_map.tags,
        {
          Name = local.l2_map[k].name_context
        },
        local.l1_map[k].tags == null ? var.tags_default : local.l1_map[k].tags,
      )
    }
  }
  output_data = {
    for k, v in var.name_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
}
