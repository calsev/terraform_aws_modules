locals {
  l1_map = {
    for k, v in var.name_map : k => merge(v, {
      name_include_app_fields         = v.name_include_app_fields == null ? var.name_include_app_fields_default : v.name_include_app_fields
      name_infix                      = v.name_infix == null ? var.name_infix_default : v.name_infix
      name_prefix                     = lower(replace(replace(v.name_prefix == null ? var.name_prefix_default : v.name_prefix, local.name_regex_prefix, "-"), "--", "-"))
      name_simple                     = lower(replace(replace(k, local.name_regex_root, "-"), "--", "-"))
      name_suffix                     = lower(replace(replace(v.name_suffix == null ? var.name_suffix_default : v.name_suffix, local.name_regex_suffix, "-"), "--", "-"))
      temp_name_convention_underscore = length(split("-", k)) > 1 ? file("Key ${k} should be in snake case") : null
    })
  }
  l2_map = {
    for k, _ in var.name_map : k => {
      temp_root_full_context     = "${var.std_map.resource_name_prefix}${local.l1_map[k].name_simple}${var.std_map.resource_name_suffix}"
      temp_root_no_context       = local.l1_map[k].name_simple
      temp_root_resource_context = "${local.l1_map[k].name_simple}${var.std_map.resource_name_suffix}"
    }
  }
  l3_map = {
    for k, _ in var.name_map : k => {
      temp_root_effective_context = local.l1_map[k].name_infix ? local.l1_map[k].name_include_app_fields ? local.l2_map[k].temp_root_full_context : local.l2_map[k].temp_root_resource_context : local.l2_map[k].temp_root_no_context
    }
  }
  l4_map = {
    for k, _ in var.name_map : k => {
      # Always use full regex because infix makes no sense as anything else
      # Always do standard replace for name_context - use name_effective for DNS, etc.
      name_context   = lower(replace("${local.l1_map[k].name_prefix}${replace(local.l2_map[k].temp_root_full_context, var.std_map.name_replace_regex, "-")}${local.l1_map[k].name_suffix}", "--", "-"))
      name_effective = lower(replace("${local.l1_map[k].name_prefix}${local.l3_map[k].temp_root_effective_context}${local.l1_map[k].name_suffix}", "--", "-"))
    }
  }
  l5_map = {
    for k, _ in var.name_map : k => {
      tags = merge(
        var.std_map.tags,
        {
          Name = local.l4_map[k].name_context
        },
        local.l1_map[k].tags == null ? var.tags_default : local.l1_map[k].tags,
      )
    }
  }
  lx_map = {
    for k, v in var.name_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k], local.l4_map[k], local.l5_map[k])
  }
  name_char_list_prefix = replace(local.name_char_list_root, "/", "") # Prefix must allow /aws/
  name_char_list_root   = length(var.name_regex_allow_list) == 0 ? local.name_char_list_std : replace(local.name_char_list_std, "/[${join("", var.name_regex_allow_list)}]/", "")
  name_char_list_std    = substr(var.std_map.name_replace_regex, 2, length(var.std_map.name_replace_regex) - 4)
  name_char_list_suffix = replace(local.name_char_list_root, ".", "") # Suffix must allow .fifo
  name_regex_prefix     = "/[${local.name_char_list_prefix}]/"
  name_regex_root       = "/[${local.name_char_list_root}]/"
  name_regex_suffix     = "/[${local.name_char_list_suffix}]/"
  output_data = {
    for k, v in local.lx_map : k => {
      for k_attr, v_attr in v : k_attr => v_attr if !startswith(k_attr, "temp_")
    }
  }
}
