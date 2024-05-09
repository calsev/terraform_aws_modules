module "name_map" {
  source                          = "../../name_map"
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  std_map                         = var.std_map
}

module "vpc_map" {
  source                  = "../../vpc/id_map"
  vpc_map                 = local.l0_map
  vpc_az_key_list_default = var.vpc_az_key_list_default
  vpc_key_default         = var.vpc_key_default
  vpc_segment_key_default = var.vpc_segment_key_default
  vpc_data_map            = var.vpc_data_map
}

locals {
  l0_map = {
    for k, v in var.group_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
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
