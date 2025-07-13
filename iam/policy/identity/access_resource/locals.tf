module "name_map" {
  source                          = "../../../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.create_doc_2_map
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

locals {
  create_doc_1_list = flatten([
    for k, v in local.lx_map : [
      for k_access, v_access in v.sid_map : merge(v, v_access, {
        k_access = k_access
      })
    ]
  ])
  create_doc_2_map = {
    for v in local.create_doc_1_list : v.k_all => merge(v, {
      name_append = "" # k_all is already k_append_access
    })
  }
  create_doc_x_map = {
    for k, v in local.create_doc_2_map : k => merge(v, module.name_map.data[k])
  }
  create_policy_map = {
    for k, v in local.create_doc_x_map : k => merge(v, {
      iam_policy_json = data.aws_iam_policy_document.this_policy_doc[v.k_all].json
    }) if v.policy_create
  }
  l0_map = {
    for k, v in var.policy_map : k => merge(v, {
      name_append = trim(replace("${v.name_append == null ? var.name_append_default == null ? "" : var.name_append_default : v.name_append}_${v.policy_name_append == null ? var.policy_name_append_default == null ? "" : var.policy_name_append_default : v.policy_name_append}", "_", "_"), "_")
      name_prefix = trim(replace("${v.name_prefix == null ? var.name_prefix_default == null ? "" : var.name_prefix_default : v.name_prefix}_${v.policy_name_prefix == null ? var.policy_name_prefix_default == null ? "" : var.policy_name_prefix_default : v.policy_name_prefix}", "_", "_"), "_")
    })
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      access_list   = v.access_list == null ? var.policy_access_list_default : v.access_list
      policy_create = v.policy_create == null ? var.policy_create_default : v.policy_create
      service_name  = v.service_name == null ? var.policy_service_name_default : v.service_name
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
          k_all = replace("${k}_${local.l0_map[k].name_append}_${k_access}", "__", "_")
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
          for k_access, v_access in v.sid_map : k_access => merge(
            v,
            v_access,
            local.create_doc_x_map[v_access.k_all],
            {
              iam_policy_doc = jsondecode(data.aws_iam_policy_document.this_policy_doc[v_access.k_all].json)
              iam_policy_arn = lookup(aws_iam_policy.policy, v_access.k_all, null) == null ? null : aws_iam_policy.policy[v_access.k_all].arn
            },
          )
        }
      }
    )
  }
}
