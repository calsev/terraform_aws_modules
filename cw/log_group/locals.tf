module "name_map" {
  source               = "../../name_map"
  name_append_default  = var.name_append_default
  name_map             = var.log_map
  name_prefix_default  = var.name_prefix_default
  name_prepend_default = var.name_prepend_default
  std_map              = var.std_map
}

module "policy_map" {
  source                      = "../../iam/policy/name_map"
  name_map                    = var.log_map
  policy_access_list_default  = var.policy_access_list_default
  policy_create_default       = var.policy_create_default
  policy_name_append_default  = var.policy_name_append_default
  policy_name_infix_default   = var.policy_name_infix_default
  policy_name_prefix_default  = var.policy_name_prefix_default
  policy_name_prepend_default = var.policy_name_prepend_default
  policy_name_suffix_default  = var.policy_name_suffix_default
  std_map                     = var.std_map
}

locals {
  l1_map = {
    for k, v in var.log_map : k => merge(v, module.name_map.data[k], module.policy_map.data[k], {
      allow_public_read  = v.allow_public_read == null ? var.log_allow_public_read_default : v.allow_public_read
      kms_key_id         = v.kms_key_id == null ? var.log_kms_key_id_default : v.kms_key_id
      log_group_class    = v.log_group_class == null ? var.log_group_class_default : v.log_group_class
      log_retention_days = v.log_retention_days == null ? var.log_retention_days_default : v.log_retention_days
      skip_destroy       = v.skip_destroy == null ? var.log_skip_destroy_default : v.skip_destroy
    })
  }
  l2_map = {
    for k, _ in var.log_map : k => {
      policy_access_list = local.l1_map[k].allow_public_read ? ["public_read", "read", "write"] : ["read", "write"]
    }
  }
  log_map = {
    for k, _ in var.log_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.log_map : k => merge(
      v,
      module.this_policy[k].data,
      {
        log_group_arn  = aws_cloudwatch_log_group.this_log_group[k].arn
        log_group_name = aws_cloudwatch_log_group.this_log_group[k].name
      },
    )
  }
}
