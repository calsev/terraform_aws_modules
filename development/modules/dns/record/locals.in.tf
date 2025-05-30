module "name_map" {
  source                = "../../name_map"
  name_map              = local.l0_map
  name_regex_allow_list = ["."]
  std_map               = var.std_map
}

locals {
  l0_map = {
    for k, v in var.record_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      alias_name_is_ip                 = v.dns_alias_name == null ? null : length(regexall("[0-9:]", substr(v.dns_alias_name, -1, 1))) > 0
      dns_alias_zone_id                = v.dns_alias_zone_id == null ? var.record_dns_alias_zone_id_default : v.dns_alias_zone_id
      dns_alias_evaluate_target_health = v.dns_alias_evaluate_target_health == null ? var.record_dns_alias_evaluate_target_health_default : v.dns_alias_evaluate_target_health
      dns_from_zone_key                = v.dns_from_zone_key == null ? var.record_dns_from_zone_key_default : v.dns_from_zone_key
      dns_ttl_type_override            = v.dns_ttl_type_override == null ? var.record_dns_ttl_type_override_default : v.dns_ttl_type_override
      dns_type                         = v.dns_type == null ? var.record_dns_type_default : v.dns_type
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      dns_alias_name   = local.l1_map[k].dns_alias_name == null ? null : local.l1_map[k].alias_name_is_ip ? local.l1_map[k].dns_alias_name : "${trim(local.l1_map[k].dns_alias_name, ".")}."
      dns_from_fqdn    = "${trim(v.dns_from_fqdn == null ? local.l1_map[k].name_simple : v.dns_from_fqdn, ".")}." # This is most of why this module exists :)
      dns_from_zone_id = v.dns_from_zone_id == null ? var.dns_data.domain_to_dns_zone_map[local.l1_map[k].dns_from_zone_key].dns_zone_id : v.dns_from_zone_id
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      is_alias_type = local.l1_map[k].dns_type == "A" && local.l2_map[k].dns_alias_name != null
    }
  }
  l4_map = {
    for k, v in local.l0_map : k => {
      dns_record_list = local.l3_map[k].is_alias_type ? null : v.dns_record_list == null ? var.record_dns_record_list_default : v.dns_record_list
      ttl             = local.l3_map[k].is_alias_type ? null : var.ttl_map[local.l1_map[k].dns_ttl_type_override == null ? local.l1_map[k].dns_type : local.l1_map[k].dns_ttl_type_override]
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k], local.l4_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
      }
    )
  }
}
