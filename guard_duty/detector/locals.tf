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
  create_feature_1_list = flatten([
    for k, v in local.lx_map : [
      for k_feat, v_feat in v.feature_map : merge(v, v_feat, {
        detector_id = aws_guardduty_detector.this_detector[k].id
        k_all       = "${k}_${k_feat}"
        k_feat      = k_feat
      })
    ]
  ])
  create_feature_x_map = {
    for v in local.create_feature_1_list : v.k_all => v
  }
  l0_map = {
    for k, v in var.detector_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      feature_map                  = v.feature_map == null ? var.detector_feature_map_default : v.feature_map
      finding_publishing_frequency = v.finding_publishing_frequency == null ? var.detector_finding_publishing_frequency_default : v.finding_publishing_frequency
      is_enabled                   = v.is_enabled == null ? var.detector_is_enabled_default : v.is_enabled
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      feature_map = {
        for k_feat, v_feat in local.l1_map[k].feature_map : k_feat => merge(v_feat, {
          add_on_list = [
            for v_add in v_feat.add_on_list : merge(v_add, {
              enabled = v_feat.enabled ? v_add.enabled : false
            })
          ]
        })
      }
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
        detector_arn = aws_guardduty_detector.this_detector[k].arn
        detector_id  = aws_guardduty_detector.this_detector[k].id
      }
    )
  }
}
