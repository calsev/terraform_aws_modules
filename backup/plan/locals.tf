module "name_map" {
  source                          = "../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  name_prepend_default            = var.name_prepend_default
  std_map                         = var.std_map
}

locals {
  create_selection_map = {
    for k, v in local.lx_map : k => merge(v, {
      plan_id = aws_backup_plan.this_plan[k].id
    })
  }
  l0_map = {
    for k, v in var.plan_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      rule_map            = v.rule_map == null ? var.plan_rule_map_default : v.rule_map
      windows_vss_enabled = v.windows_vss_enabled == null ? var.plan_windows_vss_enabled_default : v.windows_vss_enabled
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
      rule_map = {
        for k_rule, v_rule in local.l1_map[k].rule_map : k_rule => merge(v_rule, {
          backup_copy_cold_storage_after_days     = v_rule.backup_copy_cold_storage_after_days == null ? var.plan_rule_backup_copy_cold_storage_after_days_default : v_rule.backup_copy_cold_storage_after_days
          backup_copy_cold_storage_opt_in_enabled = v_rule.backup_copy_cold_storage_opt_in_enabled == null ? var.plan_rule_backup_copy_cold_storage_opt_in_enabled_default : v_rule.backup_copy_cold_storage_opt_in_enabled
          backup_copy_delete_after_days           = v_rule.backup_copy_delete_after_days == null ? var.plan_rule_backup_copy_delete_after_days_default : v_rule.backup_copy_delete_after_days
          backup_copy_destination_vault_key       = v_rule.backup_copy_destination_vault_key == null ? var.plan_rule_backup_copy_destination_vault_key_default : v_rule.backup_copy_destination_vault_key
          backup_vault_key                        = v_rule.backup_vault_key == null ? var.plan_rule_backup_vault_key_default == null ? k : var.plan_rule_backup_vault_key_default : v_rule.backup_vault_key
          completion_timeout_minutes              = v_rule.completion_timeout_minutes == null ? var.plan_rule_completion_timeout_minutes_default : v_rule.completion_timeout_minutes
          continuous_backup_enabled               = v_rule.continuous_backup_enabled == null ? var.plan_rule_continuous_backup_enabled_default : v_rule.continuous_backup_enabled
          lifecycle_cold_storage_after_days       = v_rule.lifecycle_cold_storage_after_days == null ? var.plan_rule_lifecycle_cold_storage_after_days_default : v_rule.lifecycle_cold_storage_after_days
          lifecycle_cold_storage_opt_in_enabled   = v_rule.lifecycle_cold_storage_opt_in_enabled == null ? var.plan_rule_lifecycle_cold_storage_opt_in_enabled_default : v_rule.lifecycle_cold_storage_opt_in_enabled
          lifecycle_delete_after_days             = v_rule.lifecycle_delete_after_days == null ? var.plan_rule_lifecycle_delete_after_days_default : v_rule.lifecycle_delete_after_days
          name_display                            = v_rule.name_display == null ? var.plan_rule_name_display_default : v_rule.name_display
          recovery_point_tag_map                  = v_rule.recovery_point_tag_map == null ? var.plan_rule_recovery_point_tag_map_default : v_rule.recovery_point_tag_map
          schedule_cron_expression                = v_rule.schedule_cron_expression == null ? var.plan_rule_schedule_cron_expression_default : v_rule.schedule_cron_expression
          start_delay_minutes                     = v_rule.start_delay_minutes == null ? var.plan_rule_start_delay_minutes_default : v_rule.start_delay_minutes
        })
      }
    }
  }
  l3_map = {
    for k, v in local.l0_map : k => {
      rule_map = {
        for k_rule, v_rule in local.l2_map[k].rule_map : k_rule => merge(v_rule, {
          backup_copy_destination_vault_arn = v_rule.backup_copy_destination_vault_key == null ? null : var.vault_data_map[v_rule.backup_copy_destination_vault_key].vault_arn
          backup_vault_id                   = var.vault_data_map[v_rule.backup_vault_key].vault_id
        })
      }
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
      module.selection.data[k],
      {
        plan_arn     = aws_backup_plan.this_plan[k].arn
        plan_id      = aws_backup_plan.this_plan[k].id
        plan_version = aws_backup_plan.this_plan[k].version
      }
    )
  }
}
