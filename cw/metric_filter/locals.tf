module "name_map" {
  source                          = "../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prepend_default            = var.name_prepend_default
  std_map                         = var.std_map
}

locals {
  l0_map = {
    for k, v in var.metric_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      log_group_key                = v.log_group_key == null ? var.metric_log_group_key_default : v.log_group_key
      pattern                      = v.pattern == null ? var.metric_pattern_default : v.pattern
      transformation_default_value = v.transformation_default_value == null ? var.metric_transformation_default_value_default : v.transformation_default_value
      transformation_dimension_map = v.transformation_dimension_map == null ? var.metric_transformation_dimension_map_default : v.transformation_dimension_map
      transformation_name          = v.transformation_name == null ? var.metric_transformation_name_default : v.transformation_name
      transformation_namespace     = v.transformation_namespace == null ? var.metric_transformation_namespace_default : v.transformation_namespace
      transformation_unit          = v.transformation_unit == null ? var.metric_transformation_unit_default : v.transformation_unit
      transformation_value         = v.transformation_value == null ? var.metric_transformation_value_default : v.transformation_value
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      log_group_name = var.log_data_map[local.l1_map[k].log_group_key].name_effective
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
      }
    )
  }
}
