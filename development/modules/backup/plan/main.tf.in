resource "aws_backup_plan" "this_plan" {
  for_each = local.lx_map
  dynamic "advanced_backup_setting" {
    for_each = each.value.windows_vss_enabled ? { this = {} } : {}
    content {
      backup_options = {
        WindowsVSS = "enabled"
      }
      resource_type = "EC2"
    }
  }
  name = each.value.name_effective
  dynamic "rule" {
    for_each = each.value.rule_map
    content {
      completion_window = rule.value.completion_timeout_minutes
      dynamic "copy_action" {
        for_each = rule.value.backup_copy_destination_vault_arn == null ? {} : { this = {} }
        content {
          destination_vault_arn = rule.value.backup_copy_destination_vault_arn
          lifecycle {
            cold_storage_after                        = rule.value.backup_copy_cold_storage_after_days
            delete_after                              = rule.value.backup_copy_delete_after_days
            opt_in_to_archive_for_supported_resources = rule.value.backup_copy_cold_storage_opt_in_enabled
          }
        }
      }
      enable_continuous_backup = rule.value.continuous_backup_enabled
      lifecycle {
        cold_storage_after                        = rule.value.lifecycle_cold_storage_after_days
        delete_after                              = rule.value.lifecycle_delete_after_days
        opt_in_to_archive_for_supported_resources = rule.value.lifecycle_cold_storage_opt_in_enabled
      }
      recovery_point_tags = rule.value.recovery_point_tag_map
      rule_name           = rule.value.name_display
      schedule            = rule.value.schedule_cron_expression
      start_window        = rule.value.start_delay_minutes
      target_vault_name   = rule.value.backup_vault_id
    }
  }
  tags = each.value.tags
}

module "selection" {
  source                                             = "../../backup/selection"
  iam_data                                           = var.iam_data
  plan_map                                           = local.create_selection_map
  plan_selection_condition_map_default               = var.plan_selection_condition_map_default
  plan_selection_iam_role_arn_default                = var.plan_selection_iam_role_arn_default
  plan_selection_resource_arn_match_list_default     = var.plan_selection_resource_arn_match_list_default
  plan_selection_resource_arn_not_match_list_default = var.plan_selection_resource_arn_not_match_list_default
  plan_selection_map_default                         = var.plan_selection_map_default
  plan_selection_name_display_default                = var.plan_selection_name_display_default
  plan_selection_tag_map_default                     = var.plan_selection_tag_map_default
  std_map                                            = var.std_map
}
