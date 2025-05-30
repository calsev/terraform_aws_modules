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
    name_append             = optional(string)
    name_include_app_fields = optional(bool)
    name_infix              = optional(bool)
    name_prefix             = optional(string)
    name_prepend            = optional(string)
    name_suffix             = optional(string)
    plan_id                 = string
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
  }))
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
