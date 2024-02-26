module "name_map" {
  source                          = "../../name_map"
  name_include_app_fields_default = var.instance_name_include_app_fields_default
  name_infix_default              = var.instance_name_infix_default
  name_map                        = local.l0_map
  std_map                         = var.std_map
}

locals {
  create_asg_map = {
    for k, v in local.lx_map : k => merge(v, {
      launch_template_id = module.instance_template.data[k].launch_template_id
    })
  }
  l0_map = {
    for k, v in var.instance_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        auto_scaling_group = module.asg.data[k]
        elastic_ip         = module.elastic_ip.data[k]
        instance_template  = module.instance_template.data[k]
      }
    )
  }
}
