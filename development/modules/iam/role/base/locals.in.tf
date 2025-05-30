{{ name.map() }}

module "role_policy_map" {
  source = "../../../iam/role/policy_map"
  role_map = {
    (var.name) = {
      embedded_role_policy_attach_arn_map  = var.embedded_role_policy_attach_arn_map
      embedded_role_policy_create_json_map = var.embedded_role_policy_create_json_map
      embedded_role_policy_inline_json_map = var.embedded_role_policy_inline_json_map
      embedded_role_policy_managed_name_map = merge(
        var.embedded_role_policy_managed_name_map,
        var.create_instance_profile ? {
          ssm_agent = {
            condition = true
            policy    = "AmazonSSMManagedInstanceCore"
          }
        } : {}
      )
      role_policy_attach_arn_map   = var.map_policy == null ? null : var.map_policy.role_policy_attach_arn_map
      role_policy_create_json_map  = var.map_policy == null ? null : var.map_policy.role_policy_create_json_map
      role_policy_inline_json_map  = var.map_policy == null ? null : var.map_policy.role_policy_inline_json_map
      role_policy_managed_name_map = var.map_policy == null ? null : var.map_policy.role_policy_managed_name_map
    }
  }
  role_policy_attach_arn_map_default   = var.role_policy_attach_arn_map_default
  role_policy_create_json_map_default  = var.role_policy_create_json_map_default
  role_policy_inline_json_map_default  = var.role_policy_inline_json_map_default
  role_policy_managed_name_map_default = var.role_policy_managed_name_map_default
}

locals {
  l0_map = merge(
    {
      (var.name) = {
        name_override = var.name_override_default
        {{ name.map_item() }}
      }
    },
    {
      for k, v in module.role_policy_map.data[var.name].role_policy_create_json_map : k => {
        {{ name.map_item() }}
      }
    },
  )
  l1_map = merge(module.name_map.data[var.name], {
    assume_role_account_map  = var.assume_role_account_map
    assume_role_service_list = var.assume_role_service_list
    enable_assume_role       = length(var.assume_role_account_map) > 0 || length(var.assume_role_service_list) > 0
    create_instance_profile  = var.create_instance_profile
    max_session_duration_m   = var.max_session_duration_m
    role_policy_attach_arn_map = {
      for name, arn in module.role_policy_map.data[var.name].role_policy_attach_arn_map : "2-attached-${name}" => arn
    }
    role_policy_create_doc_map = {
      for k, v in module.role_policy_map.data[var.name].role_policy_create_json_map : k => jsondecode(v)
    }
    role_policy_inline_doc_map = {
      for k, v in module.role_policy_map.data[var.name].role_policy_inline_json_map : k => jsondecode(v)
    }
    role_policy_managed_arn_map = {
      for name, policy in module.role_policy_map.data[var.name].role_policy_managed_name_map : "1-managed-${name}" => "arn:${var.std_map.iam_partition}:iam::aws:policy/${policy}"
    }
    role_path = var.role_path_default
  })
  l2_map = {
    assume_role_doc = var.assume_role_json == null ? module.assume_role_policy["this"].iam_policy_doc_assume_role : jsondecode(var.assume_role_json)
    role_path = local.l1_map.role_path == null ? null : "/${trim(local.l1_map.role_path, "/")}/"
  }
  l3_map = {
    role_policy_create_arn_map = {
      for k, _ in local.l1_map.role_policy_create_doc_map : "3-created-${k}" => aws_iam_policy.this_created_policy[k].arn
    }
  }
  l4_map = {
    role_policy_all_attached_arn_map = merge(
      local.l1_map.role_policy_managed_arn_map,
      local.l1_map.role_policy_attach_arn_map,
      local.l3_map.role_policy_create_arn_map,
    )
  }
  # tflint-ignore: terraform_unused_declarations
  mutual_exclusion_assume_role = local.l1_map.enable_assume_role && var.assume_role_json == null || !local.l1_map.enable_assume_role && var.assume_role_json != null ? null : file("ERROR: Exactly one specification of assuming the role is required")
  output_data = merge(local.l1_map, local.l2_map, local.l3_map, local.l4_map, {
    iam_instance_profile_arn = var.create_instance_profile ? aws_iam_instance_profile.instance_profile["this"].arn : null
    iam_role_arn             = aws_iam_role.this_iam_role.arn
    iam_role_id              = aws_iam_role.this_iam_role.id
  })
}
