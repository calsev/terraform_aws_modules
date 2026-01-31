module "name_map" {
  source                          = "../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

module "vpc_map" {
  source                              = "../../vpc/id_map"
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_data_map                        = var.vpc_data_map
  vpc_key_default                     = var.vpc_key_default
  vpc_map                             = local.l0_map
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
  vpc_segment_key_default             = var.vpc_segment_key_default
}

locals {
  l0_map = {
    for k, v in var.connection_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      catalog_id          = v.catalog_id == null ? var.connection_catalog_id_default == null ? var.std_map.aws_account_id : var.connection_catalog_id_default : v.catalog_id
      connection_type     = v.connection_type == null ? var.connection_type_default : v.connection_type
      match_criteria_list = v.match_criteria_list == null ? var.connection_match_criteria_list_default : v.match_criteria_list
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      availability_zone_name = var.vpc_data_map[local.l1_map[k].vpc_key].segment_map[local.l1_map[k].vpc_segment_key].subnet_map[local.l1_map[k].vpc_az_key_list[0]].availability_zone_name
      vpc_subnet_id          = local.l1_map[k].vpc_subnet_id_list[0]
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        connection_arn = aws_glue_connection.this_connection[k].arn
        connection_id  = aws_glue_connection.this_connection[k].id
      },
    )
  }
}
