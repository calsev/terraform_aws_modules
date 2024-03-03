module "name_map" {
  source                          = "../../name_map"
  name_include_app_fields_default = var.key_name_include_app_fields_default
  name_infix_default              = var.key_name_infix_default
  name_map                        = local.l0_map
  std_map                         = var.std_map
}

locals {
  l0_map = {
    for k, v in var.key_map : k => v
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
        for k_secret, v_secret in v : k_secret => v_secret if !contains([], k_secret)
      },
      module.key_secret.data[k],
      {
        key_pair_id   = aws_key_pair.generated_key[k].key_pair_id
        key_pair_name = aws_key_pair.generated_key[k].key_name
      }
    )
  }
}
