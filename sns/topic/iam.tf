module "resource_policy" {
  for_each = local.topic_policy_map
  source   = "../../iam/policy/resource/sns/topic"
  sid_map = {
    Event = {
      access = "write"
      condition_map = {
        source_account = local.source_account_condition
        source_arn = {
          test = "ArnLike"
          value_list = [
            "arn:${var.std_map.iam_partition}:events:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:rule/*",
          ]
          variable = "AWS:SourceArn"
        }
      }
      identifier_list = ["events.amazonaws.com"]
      identifier_type = "Service"
    }
  }
  sns_topic_name = each.value.name_effective
  std_map        = var.std_map
}

module "topic_policy" {
  source                          = "../../iam/policy/identity/sns/topic"
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
