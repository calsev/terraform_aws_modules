resource "aws_kms_key" "this_key" {
  for_each                           = local.lx_map
  bypass_policy_lockout_safety_check = each.value.policy_lockout_safety_check_bypass_enabled
  customer_master_key_spec           = each.value.customer_master_key_spec
  custom_key_store_id                = each.value.custom_key_store_id
  deletion_window_in_days            = each.value.deletion_window_days
  enable_key_rotation                = each.value.key_rotation_enabled
  is_enabled                         = each.value.is_enabled
  key_usage                          = each.value.key_usage
  multi_region                       = each.value.multi_region_enabled
  policy                             = each.value.iam_policy_json
  rotation_period_in_days            = each.value.rotation_period_days
  tags                               = each.value.tags
  xks_key_id                         = each.value.xks_key_id
}

resource "aws_kms_alias" "this_alias" {
  for_each      = local.lx_map
  name          = "alias/${each.value.name_effective}"
  target_key_id = aws_kms_key.this_key[each.key].key_id
}

module "key_resource_policy" {
  source               = "../../iam/policy/resource/kms/key"
  for_each             = local.lx_map
  allow_cloudtrail     = each.value.allow_cloudtrail
  allow_iam_delegation = each.value.allow_iam_delegation
  key_id               = aws_kms_key.this_key[each.key].id
  std_map              = var.std_map
}

module "key_policy" {
  source                          = "../../iam/policy/identity/kms/key"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  policy_access_list_default      = var.policy_access_list_default
  policy_create_default           = var.policy_create_default
  policy_map                      = local.create_policy_map
  policy_name_append_default      = var.policy_name_append_default
  policy_name_prefix_default      = var.policy_name_prefix_default
  std_map                         = var.std_map
}
