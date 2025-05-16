variable "iam_data" {
  type = object({
    iam_role_arn_backup_create = string
  })
}

variable "name_append_default" {
  type        = string
  default     = ""
  description = "Appended after key"
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = true
  description = "If true, standard project context will be prefixed to the name. Ignored if not name_infix."
}

variable "name_infix_default" {
  type        = bool
  default     = true
  description = "If true, standard project prefix and resource suffix will be added to the name"
}

variable "name_prefix_default" {
  type        = string
  default     = ""
  description = "Prepended before context prefix"
}

variable "name_prepend_default" {
  type        = string
  default     = ""
  description = "Prepended before key"
}

# tflint-ignore: terraform_unused_declarations
variable "name_regex_allow_list" {
  type        = list(string)
  default     = []
  description = "By default, all punctuation is replaced by -"
}

variable "name_suffix_default" {
  type        = string
  default     = ""
  description = "Appended after context suffix"
}

variable "plan_map" {
  type = map(object({
    rule_map = optional(map(object({
      backup_copy_cold_storage_after_days     = optional(number)
      backup_copy_cold_storage_opt_in_enabled = optional(bool)
      backup_copy_delete_after_days           = optional(number)
      backup_copy_destination_vault_key       = optional(string)
      backup_vault_key                        = optional(string)
      completion_timeout_minutes              = optional(number)
      continuous_backup_enabled               = optional(bool)
      lifecycle_cold_storage_after_days       = optional(number)
      lifecycle_cold_storage_opt_in_enabled   = optional(bool)
      lifecycle_delete_after_days             = optional(number)
      name_append                             = optional(string)
      name_include_app_fields                 = optional(bool)
      name_infix                              = optional(bool)
      name_prefix                             = optional(string)
      name_prepend                            = optional(string)
      name_suffix                             = optional(string)
      name_display                            = optional(string)
      recovery_point_tag_map                  = optional(map(string))
      schedule_cron_expression                = optional(string)
      start_delay_minutes                     = optional(number)
    })))
    selection_map = optional(map(object({
      condition_map = optional(map(object({
        string_equal_map = optional(map(object({
          key   = string
          value = string
        })), {})
        string_like_map = optional(map(object({
          key   = string
          value = string
        })), {})
        string_not_equal_map = optional(map(object({
          key   = string
          value = string
        })), {})
        string_not_like_map = optional(map(object({
          key   = string
          value = string
        })), {})
      })))
      iam_role_arn                = optional(string)
      name_display                = optional(string)
      resource_arn_match_list     = optional(list(string))
      resource_arn_not_match_list = optional(list(string))
      selection_tag_map = optional(map(object({
        key            = string
        operation_type = string
        value          = string
      })))
    })))
    windows_vss_enabled = optional(bool)
  }))
}

variable "plan_rule_map_default" {
  type = map(object({
    backup_copy_cold_storage_after_days     = optional(number)
    backup_copy_cold_storage_opt_in_enabled = optional(bool)
    backup_copy_delete_after_days           = optional(number)
    backup_copy_destination_vault_key       = optional(string)
    backup_vault_key                        = optional(string)
    completion_timeout_minutes              = optional(number)
    continuous_backup_enabled               = optional(bool)
    lifecycle_cold_storage_after_days       = optional(number)
    lifecycle_cold_storage_opt_in_enabled   = optional(bool)
    lifecycle_delete_after_days             = optional(number)
    name_append                             = optional(string)
    name_include_app_fields                 = optional(bool)
    name_infix                              = optional(bool)
    name_prefix                             = optional(string)
    name_prepend                            = optional(string)
    name_suffix                             = optional(string)
    name_display                            = optional(string)
    recovery_point_tag_map                  = optional(map(string))
    schedule_cron_expression                = optional(string)
    start_delay_minutes                     = optional(number)
  }))
  default = {
    point_in_time = {
      backup_copy_cold_storage_after_days     = null
      backup_copy_cold_storage_opt_in_enabled = null
      backup_copy_delete_after_days           = null
      backup_copy_destination_vault_key       = null
      backup_vault_key                        = null
      completion_timeout_minutes              = null
      continuous_backup_enabled               = true
      lifecycle_cold_storage_after_days       = null
      lifecycle_cold_storage_opt_in_enabled   = null
      lifecycle_delete_after_days             = 7 # Less than 7 is a medium-severity security finding
      name_append                             = null
      name_include_app_fields                 = null
      name_infix                              = null
      name_prefix                             = null
      name_prepend                            = null
      name_suffix                             = null
      name_display                            = "ContinuousBackupForPointInTimeRecovery"
      recovery_point_tag_map                  = null
      schedule_cron_expression                = null
      start_delay_minutes                     = null
    }
    snapshot = {
      backup_copy_cold_storage_after_days     = null
      backup_copy_cold_storage_opt_in_enabled = null
      backup_copy_delete_after_days           = null
      backup_copy_destination_vault_key       = null
      backup_vault_key                        = null
      completion_timeout_minutes              = null
      continuous_backup_enabled               = null
      lifecycle_cold_storage_after_days       = null
      lifecycle_cold_storage_opt_in_enabled   = null
      lifecycle_delete_after_days             = null
      name_append                             = null
      name_include_app_fields                 = null
      name_infix                              = null
      name_prefix                             = null
      name_prepend                            = null
      name_suffix                             = null
      name_display                            = "SnapshotBackupForLongTermRetention"
      recovery_point_tag_map                  = null
      schedule_cron_expression                = null
      start_delay_minutes                     = null
    }
  }
}

variable "plan_rule_backup_copy_cold_storage_after_days_default" {
  type        = number
  default     = null
  description = "Ignored unless copy vault key is provided"
}

variable "plan_rule_backup_copy_cold_storage_opt_in_enabled_default" {
  type        = bool
  default     = false
  description = "Ignored unless copy vault key is provided"
}

variable "plan_rule_backup_copy_delete_after_days_default" {
  type        = number
  default     = null
  description = "Ignored unless copy vault key is provided"
}

variable "plan_rule_backup_copy_destination_vault_key_default" {
  type        = string
  default     = null
  description = "Defaults to key for plan"
}

variable "plan_rule_backup_vault_key_default" {
  type    = string
  default = null
}

variable "plan_rule_completion_timeout_minutes_default" {
  type    = number
  default = 180
}

variable "plan_rule_continuous_backup_enabled_default" {
  type    = bool
  default = false
}

variable "plan_rule_name_display_default" {
  type        = string
  default     = null
  description = "Must contain only alphanumeric characters, hyphens, underscores, and periods"
}

variable "plan_rule_lifecycle_cold_storage_after_days_default" {
  type    = number
  default = null
}

variable "plan_rule_lifecycle_cold_storage_opt_in_enabled_default" {
  type    = bool
  default = false
}

variable "plan_rule_lifecycle_delete_after_days_default" {
  type    = number
  default = null
}

variable "plan_rule_recovery_point_tag_map_default" {
  type    = map(string)
  default = {}
}

variable "plan_rule_schedule_cron_expression_default" {
  type    = string
  default = "cron(0 7 ? * * *)" # every day at 7am UTC
}

variable "plan_rule_start_delay_minutes_default" {
  type    = number
  default = 60
}

variable "plan_selection_map_default" {
  type = map(object({
    condition_map = optional(map(object({
      string_equal_map = optional(map(object({
        key   = string
        value = string
      })), {})
      string_like_map = optional(map(object({
        key   = string
        value = string
      })), {})
      string_not_equal_map = optional(map(object({
        key   = string
        value = string
      })), {})
      string_not_like_map = optional(map(object({
        key   = string
        value = string
      })), {})
    })))
    iam_role_arn                = optional(string)
    name_display                = optional(string)
    resource_arn_match_list     = optional(list(string))
    resource_arn_not_match_list = optional(list(string))
    selection_tag_map = optional(map(object({
      key            = string
      operation_type = string
      value          = string
    })))
  }))
  default = {}
}

variable "plan_selection_condition_map_default" {
  type = map(object({
    string_equal_map = optional(map(object({
      key   = string
      value = string
    })), {})
    string_like_map = optional(map(object({
      key   = string
      value = string
    })), {})
    string_not_equal_map = optional(map(object({
      key   = string
      value = string
    })), {})
    string_not_like_map = optional(map(object({
      key   = string
      value = string
    })), {})
  }))
  default = {}
}

variable "plan_selection_iam_role_arn_default" {
  type        = string
  default     = null
  description = "Defaults to general role from IAM data"
}

variable "plan_selection_name_display_default" {
  type    = string
  default = null
}

variable "plan_selection_resource_arn_match_list_default" {
  type        = list(string)
  default     = ["*"]
  description = "Can have wilcards"
}

variable "plan_selection_resource_arn_not_match_list_default" {
  type        = list(string)
  default     = []
  description = "Can have wilcards"
}

variable "plan_selection_tag_map_default" {
  type = map(object({
    key            = string
    operation_type = string
    value          = string
  }))
  default = {}
}

variable "plan_windows_vss_enabled_default" {
  type    = bool
  default = false
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    config_name                    = string
    env                            = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}

variable "vault_data_map" {
  type = map(object({
    vault_arn = string
    vault_id  = string
  }))
}
