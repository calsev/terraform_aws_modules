module "name_map" {
  source                          = "../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_regex_allow_list           = var.name_regex_allow_list
  name_suffix_default             = var.name_suffix_default
  std_map                         = var.std_map
}

locals {
  l0_map = {
    for k, v in var.email_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      comms_ses_domain_key      = v.comms_ses_domain_key == null ? var.email_comms_ses_domain_key_default : v.comms_ses_domain_key
      enabled                   = v.enabled == null ? var.email_enabled_default : v.enabled
      iam_role_arn_custom       = v.iam_role_arn_custom == null ? var.email_iam_role_arn_custom_default : v.iam_role_arn_custom
      pinpoint_application_id   = v.pinpoint_application_id == null ? var.email_pinpoint_application_id_default : v.pinpoint_application_id
      ses_configuration_set_key = v.ses_configuration_set_key == null ? var.email_ses_configuration_set_key_default : v.ses_configuration_set_key
      ses_identity_arn_custom   = v.ses_identity_arn_custom == null ? var.email_ses_identity_arn_custom_default : v.ses_identity_arn_custom
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      ses_configuration_set_name = local.l1_map[k].ses_configuration_set_key == null ? null : var.comms_data.ses_config_map[local.l1_map[k].ses_configuration_set_key].name_effective
      ses_identity_arn           = local.l1_map[k].ses_identity_arn_custom == null ? var.comms_data.ses_domain_map[local.l1_map[k].comms_ses_domain_key].identity_arn : local.l1_map[k].ses_identity_arn_custom
      from_username              = v.from_username_custom == null ? local.l1_map[k].name_simple : v.from_username_custom
      iam_role_arn               = local.l1_map[k].iam_role_arn_custom == null ? var.comms_data.iam_policy_arn_map_mobile_analytics["write"] : local.l1_map[k].iam_role_arn_custom
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      from_address = "${local.l2_map[k].from_username}@${var.comms_data.ses_domain_map[local.l1_map[k].comms_ses_domain_key].mail_from_domain}"
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
        messages_per_second = aws_pinpoint_email_channel.email[k].messages_per_second
      },
    )
  }
}
