locals {
  all_attached_policy_arn_map = merge(local.managed_policy_arn_map, local.attach_policy_arn_map, local.create_policy_arn_map)
  assume_role_json            = var.assume_role_json != null ? var.assume_role_json : data.aws_iam_policy_document.service_assume_role["this"].json
  attach_policy_arn_map = {
    for name, arn in var.attach_policy_arn_map : "2-attached-${name}" => arn
  }
  create_policy_arn_map = {
    for name, _ in var.create_policy_json_map : "3-created-${name}" => aws_iam_policy.this_created_policy[name].arn
  }
  inline_policy_json_map = var.inline_policy_json_map == null ? {} : var.inline_policy_json_map
  # tflint-ignore: terraform_unused_declarations
  mutual_exclusion_assume_role = var.assume_role_json == null && var.assume_role_service_list != null || var.assume_role_json != null && var.assume_role_service_list == null ? null : file("ERROR: Exactly one specification of assuming the role is required")
  name_prefix                  = local.name_prefix_sanitized == "" ? "" : replace("${local.name_prefix_sanitized}-", "--", "-")
  name_prefix_sanitized        = replace(var.name_prefix, "/[._]/", "-")
  managed_policy_arn_map = {
    for name, policy in var.managed_policy_name_map == null ? {} : var.managed_policy_name_map : "1-managed-${name}" => "arn:${var.std_map.iam_partition}:iam::aws:policy/${policy}"
  }
  policy_name_map = {
    for name, _ in var.create_policy_json_map : name => "${var.std_map.resource_name_prefix}${replace(name, "_", "-")}${var.std_map.resource_name_suffix}"
  }
  resource_name = "${var.std_map.resource_name_prefix}${replace(var.name, "/[._]/", "-")}${var.std_map.resource_name_suffix}"
  role_name     = var.name_infix ? "${local.name_prefix}${local.resource_name}" : "${local.name_prefix}${replace(var.name, "/[._]/", "-")}"
  role_path     = var.role_path == null ? null : replace("/${var.role_path}/", "////", "/")
  tags = merge(
    var.std_map.tags,
    {
      Name = local.resource_name
    }
  )
}
