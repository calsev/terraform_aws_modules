module "name_map" {
  source   = "../name_map"
  name_map = var.param_map
  std_map  = var.std_map
}

locals {
  l1_map = {
    for k, v in var.param_map : k => merge(v, module.name_map.data[k], {
      kms_key_id = v.kms_key_id == null ? var.param_kms_key_id_default : v.kms_key_id
      tier       = v.tier == null ? var.param_tier_default : v.tier
    })
  }
  output_data = {
    for k, v in var.param_map : k => merge(local.param_map[k], {
    })
  }
  param_map = {
    for k, v in var.param_map : k => merge(local.l1_map[k])
  }
}
