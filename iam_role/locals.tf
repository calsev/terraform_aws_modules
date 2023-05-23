locals {
  l1_map = {
    assume_role_service_list = var.assume_role_service_list
    enable_assume_role       = var.assume_role_service_list == null ? false : true
    create_instance_profile  = var.create_instance_profile
    max_session_duration_m   = var.max_session_duration_m
    name                     = replace(var.name, var.std_map.name_replace_regex, "-")
    name_prefix_sanitized    = trim(replace(var.name_prefix, var.std_map.name_replace_regex, "-"), "-")
    policy_attach_arn_map = {
      for name, arn in var.policy_attach_arn_map : "2-attached-${name}" => arn
    }
    policy_create_doc_map = {
      for k, v in var.policy_create_json_map : k => jsondecode(v)
    }
    policy_inline_doc_map = var.policy_inline_json_map == null ? {} : {
      for k, v in var.policy_inline_json_map : k => jsondecode(v)
    }
    policy_managed_arn_map = {
      for name, policy in var.policy_managed_name_map == null ? {} : var.policy_managed_name_map : "1-managed-${name}" => "arn:${var.std_map.iam_partition}:iam::aws:policy/${policy}"
    }
    role_path = var.role_path == null ? null : "/${trim(var.role_path, "/")}/"
  }
  l2_map = {
    assume_role_doc = var.assume_role_json == null ? module.assume_role_policy["this"].iam_policy_doc_assume_role : jsondecode(var.assume_role_json)
    create_policy_name_map = {
      for name, _ in local.l1_map.policy_create_doc_map : name => "${var.std_map.resource_name_prefix}${replace(name, var.std_map.name_replace_regex, "-")}${var.std_map.resource_name_suffix}"
    }
    name_context = "${var.std_map.resource_name_prefix}${local.l1_map.name}${var.std_map.resource_name_suffix}"
    name_prefix  = local.l1_map.name_prefix_sanitized == "" ? "" : "${local.l1_map.name_prefix_sanitized}-"
  }
  l3_map = {
    create_policy_tag_map = {
      for k, v in local.l2_map.create_policy_name_map : k => merge(
        var.std_map.tags,
        {
          Name = v
        }
      )
    }
    role_name = var.name_infix ? "${local.l2_map.name_prefix}${local.l2_map.name_context}" : "${local.l2_map.name_prefix}${local.l1_map.name}"
    tags = !var.tag ? null : merge(
      var.std_map.tags,
      {
        Name = local.l2_map.name_context
      }
    )
  }
  l4_map = {
    policy_create_arn_map = {
      for name, _ in var.policy_create_json_map : "3-created-${name}" => aws_iam_policy.this_created_policy[name].arn
    }
  }
  l5_map = {
    policy_all_attached_arn_map = merge(local.l1_map.policy_managed_arn_map, local.l1_map.policy_attach_arn_map, local.l4_map.policy_create_arn_map)
  }
  # tflint-ignore: terraform_unused_declarations
  mutual_exclusion_assume_role = var.assume_role_json == null && var.assume_role_service_list != null || var.assume_role_json != null && var.assume_role_service_list == null ? null : file("ERROR: Exactly one specification of assuming the role is required")
  output_data = merge(local.l1_map, local.l2_map, local.l3_map, local.l4_map, local.l5_map, {
    iam_instance_profile_arn = var.create_instance_profile ? aws_iam_instance_profile.instance_profile["this"].arn : null
    iam_role_arn             = aws_iam_role.this_iam_role.arn
    iam_role_id              = aws_iam_role.this_iam_role.id
  })
}
