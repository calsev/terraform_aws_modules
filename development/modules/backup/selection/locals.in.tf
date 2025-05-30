{{ name.map() }}

locals {
  l0_1_map = {
    for k, v in var.plan_map : k => merge(v, {
      selection_map = v.selection_map == null ? var.plan_selection_map_default : v.selection_map
    })
  }
  l0_2_list = flatten([
    for k, v in local.l0_1_map : [
      for k_sel, v_sel in v.selection_map : merge(v, v_sel, {
        k_all = "${k}_${k_sel}"
      })
    ]
  ])
  l0_map = {
    for v in local.l0_2_list : v.k_all => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      condition_map               = v.condition_map == null ? var.plan_selection_condition_map_default : v.condition_map
      iam_role_arn                = v.iam_role_arn == null ? var.plan_selection_iam_role_arn_default == null ? var.iam_data.iam_role_arn_backup_create : var.plan_selection_iam_role_arn_default : v.iam_role_arn
      name_display                = v.name_display == null ? var.plan_selection_name_display_default : v.name_display
      resource_arn_match_list     = v.resource_arn_match_list == null ? var.plan_selection_resource_arn_match_list_default : v.resource_arn_match_list
      resource_arn_not_match_list = v.resource_arn_not_match_list == null ? var.plan_selection_resource_arn_not_match_list_default : v.resource_arn_not_match_list
      selection_tag_map           = v.selection_tag_map == null ? var.plan_selection_tag_map_default : v.selection_tag_map
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
    for k, v in local.l0_1_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        selection_map = {
          for k_sel, _ in v.selection_map : k_sel => merge(local.lx_map["${k}_${k_sel}"], {
            selection_id = aws_backup_selection.this_selection["${k}_${k_sel}"].id
          })
        }
      }
    )
  }
}
