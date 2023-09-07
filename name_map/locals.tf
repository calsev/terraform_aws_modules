locals {
  l1_map = {
    for k, v in var.name_map : k => merge(v, {
      name_infix  = v.name_infix == null ? var.name_infix_default : v.name_infix
      name_prefix = replace(replace(v.name_prefix == null ? var.name_prefix_default : v.name_prefix, "/[_.]/", "-"), "--", "-") # Prefix must allow /aws/
      name_simple = replace(replace(k, local.name_regex, "-"), "--", "-")
      name_suffix = replace(replace(v.name_suffix == null ? var.name_suffix_default : v.name_suffix, var.std_map.name_replace_regex, "-"), "--", "-")
    })
  }
  l2_map = {
    for k, _ in var.name_map : k => {
      # Always use full regex because infix makes no sense as anything else
      # Always do standard replace for name_context - use name_effective for DNS, etc.
      name_context = replace("${local.l1_map[k].name_prefix}${replace("${var.std_map.resource_name_prefix}${k}${var.std_map.resource_name_suffix}${local.l1_map[k].name_suffix}", var.std_map.name_replace_regex, "-")}", "--", "-")
    }
  }
  l3_map = {
    for k, _ in var.name_map : k => {
      name_effective = local.l1_map[k].name_infix ? local.l2_map[k].name_context : "${local.l1_map[k].name_prefix}${local.l1_map[k].name_simple}${local.l1_map[k].name_suffix}"
      tags = merge(
        var.std_map.tags,
        {
          Name = local.l2_map[k].name_context
        },
        local.l1_map[k].tags == null ? var.tags_default : local.l1_map[k].tags,
      )
    }
  }
  name_regex                   = "/[${join("", local.name_regex_char_list)}]/"
  name_regex_char_list         = [for char in local.name_regex_char_list_default : char if !contains(var.name_regex_allow_list, char)]
  name_regex_char_list_default = ["_", ".", "/"]
  output_data = {
    for k, v in var.name_map : k => {
      for k_attr, v_attr in merge(local.l1_map[k], local.l2_map[k], local.l3_map[k]) : k_attr => v_attr if !endswith(k_attr, "_expanded")
    }
  }
}
