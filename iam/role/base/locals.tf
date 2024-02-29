module "role_policy_map" {
  source = "../../../iam/role/policy_map"
  role_map = {
    (var.name) = {
      embedded_role_policy_attach_arn_map   = var.embedded_role_policy_attach_arn_map
      embedded_role_policy_create_json_map  = var.embedded_role_policy_create_json_map
      embedded_role_policy_inline_json_map  = var.embedded_role_policy_inline_json_map
      embedded_role_policy_managed_name_map = var.embedded_role_policy_managed_name_map
      role_policy_attach_arn_map            = var.map_policy == null ? null : var.map_policy.role_policy_attach_arn_map
      role_policy_create_json_map           = var.map_policy == null ? null : var.map_policy.role_policy_create_json_map
      role_policy_inline_json_map           = var.map_policy == null ? null : var.map_policy.role_policy_inline_json_map
      role_policy_managed_name_map          = var.map_policy == null ? null : var.map_policy.role_policy_managed_name_map
    }
  }
  role_policy_attach_arn_map_default   = var.role_policy_attach_arn_map_default
  role_policy_create_json_map_default  = var.role_policy_create_json_map_default
  role_policy_inline_json_map_default  = var.role_policy_inline_json_map_default
  role_policy_managed_name_map_default = var.role_policy_managed_name_map_default
}

module "name_map" {
  source = "../../../name_map"
  name_map = {
    (var.name) = merge(
      {
        this = {
          name_include_app_fields = var.name_include_app_fields
          name_infix              = var.name_infix
          name_prefix             = var.name_prefix
        }
      },
      {
        for k, v in module.role_policy_map.data[var.name].role_policy_create_json_map : k => {
          name_include_app_fields = var.name_include_app_fields
          name_infix              = var.name_infix
          name_prefix             = var.name_prefix
        }
      },
    )
  }
  std_map = var.std_map
}

locals {
  l1_map = merge(module.name_map.data[var.name], {
    assume_role_service_list = var.assume_role_service_list
    enable_assume_role       = var.assume_role_service_list == null ? false : length(var.assume_role_service_list) == 0 ? false : true
    create_instance_profile  = var.create_instance_profile
    max_session_duration_m   = var.max_session_duration_m
    policy_attach_arn_map = {
      for name, arn in module.role_policy_map.data[var.name].role_policy_attach_arn_map : "2-attached-${name}" => arn
    }
    policy_create_doc_map = {
      for k, v in module.role_policy_map.data[var.name].role_policy_create_json_map : k => jsondecode(v)
    }
    policy_inline_doc_map = {
      for k, v in module.role_policy_map.data[var.name].role_policy_inline_json_map : k => jsondecode(v)
    }
    policy_managed_arn_map = {
      for name, policy in module.role_policy_map.data[var.name].role_policy_managed_name_map : "1-managed-${name}" => "arn:${var.std_map.iam_partition}:iam::aws:policy/${policy}"
    }
    role_path = var.role_path == null ? null : "/${trim(var.role_path, "/")}/"
  })
  l2_map = {
    assume_role_doc = var.assume_role_json == null ? module.assume_role_policy["this"].iam_policy_doc_assume_role : jsondecode(var.assume_role_json)
  }
  l3_map = {
    policy_create_arn_map = {
      for k, _ in local.l1_map.policy_create_doc_map : "3-created-${k}" => aws_iam_policy.this_created_policy[k].arn
    }
  }
  l4_map = {
    policy_all_attached_arn_map = merge(
      local.l1_map.policy_managed_arn_map,
      local.l1_map.policy_attach_arn_map,
      local.l3_map.policy_create_arn_map,
    )
  }
  # tflint-ignore: terraform_unused_declarations
  mutual_exclusion_assume_role = var.assume_role_json == null && var.assume_role_service_list != null || var.assume_role_json != null && var.assume_role_service_list == null ? null : file("ERROR: Exactly one specification of assuming the role is required")
  output_data = merge(local.l1_map, local.l2_map, local.l3_map, local.l4_map, {
    iam_instance_profile_arn = var.create_instance_profile ? aws_iam_instance_profile.instance_profile["this"].arn : null
    iam_role_arn             = aws_iam_role.this_iam_role.arn
    iam_role_id              = aws_iam_role.this_iam_role.id
  })
}
