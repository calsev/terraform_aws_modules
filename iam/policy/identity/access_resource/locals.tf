locals {
  create_doc_1_list = flatten([
    for k, v in local.lx_map : [
      for k_access, v_access in v.sid_map : merge(v, v_access, {
        k_access = k_access
      })
    ]
  ])
  create_doc_x_map = {
    for v in local.create_doc_1_list : v.k_all => v
  }
  create_policy_map = {
    for k, v in local.create_doc_x_map : k => merge(v, {
      iam_policy_json = data.aws_iam_policy_document.this_policy_doc[v.k_all].json
      name_append     = "" # Appended here
    })
  }
  l0_map = {
    for k, v in var.policy_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      access_list  = v.access_list == null ? var.policy_access_list_default : v.access_list
      name_append  = v.name_append == null || v.name_append == "" ? trim("${var.name_append_default}_${var.policy_name_append_default}", "_") : v.name_append
      service_name = v.service_name == null ? var.policy_service_name_default : v.service_name
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      pascal_map = {
        for resource_type, _ in v.resource_map : resource_type => join("", [for part in split("-", replace(resource_type, var.std_map.name_replace_regex, "-")) : title(part)])
      }
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      sid_map = {
        for k_access in local.l1_map[k].access_list : k_access => {
          k_all = replace("${k}_${local.l1_map[k].name_append}_${k_access}", "__", "_")
          resource_map = {
            for resource_type, resource_name_list in v.resource_map : resource_type => {
              resource_list = resource_name_list
              sid           = "${local.l2_map[k].pascal_map[resource_type]}${var.std_map.access_title_map[k_access]}"
            } if length(var.std_map.service_resource_access_action[local.l1_map[k].service_name][resource_type][k_access]) > 0 && length(resource_name_list) > 0
          }
        }
      }
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        policy_map = {
          for k_access, v_access in v.sid_map : k_access => module.this_policy.data[v_access.k_all]
        }
      }
    )
  }
}
