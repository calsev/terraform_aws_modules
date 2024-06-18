module "name_map" {
  source                          = "../../../name_map"
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  std_map                         = var.std_map
}

locals {
  l0_map = {
    for k, v in var.analyzer_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      analyzer_type     = v.analyzer_type == null ? var.analyzer_type_default : v.analyzer_type
      unused_access_age = v.unused_access_age == null ? var.analyzer_unused_access_age_default : v.unused_access_age
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      has_configuration = endswith(local.l1_map[k].analyzer_type, "UNUSED_ACCESS")
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
