{{ name.map() }}

locals {
  l0_map = {
    for k, v in var.deployment_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      compute_platform = v.compute_platform == null ? var.deployment_compute_platform_default : v.compute_platform
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
        application_arn = aws_codedeploy_app.this_app[k].arn
        application_id  = aws_codedeploy_app.this_app[k].application_id
      }
    )
  }
}
