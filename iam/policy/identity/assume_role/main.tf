data "aws_iam_policy_document" "this_policy_doc" {
  for_each = local.lx_map
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    resources = each.value.iam_role_arn_list
  }
}

module "this_policy" {
  source                          = "../../../../iam/policy/identity/base"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  policy_create_default           = var.policy_create_default
  policy_map                      = local.create_policy_map
  policy_name_append_default      = var.policy_name_append_default
  policy_name_prefix_default      = var.policy_name_prefix_default
  std_map                         = var.std_map
}
