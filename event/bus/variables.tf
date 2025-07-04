variable "bus_map" {
  type = map(object({
    archive_retention_days        = optional(number)
    event_bus_name                = optional(string) # If provided, a bus will not be created
    logging_enabled               = optional(bool)
    logging_excluded_detail_types = optional(list(string))
    log_retention_days            = optional(number)
    name_append                   = optional(string)
    name_include_app_fields       = optional(bool)
    name_infix                    = optional(bool)
    name_prefix                   = optional(string)
    name_prepend                  = optional(string)
    name_suffix                   = optional(string)
    policy_access_list            = optional(list(string))
    policy_create                 = optional(bool)
    policy_name_append            = optional(string)
    sid_map = optional(map(object({
      access = string
      condition_map = optional(map(object({
        test       = string
        value_list = list(string)
        variable   = string
      })))
      identifier_list = optional(list(string))
      identifier_type = optional(string)
    })))
  }))
}

variable "bus_archive_retention_days_default" {
  type        = number
  default     = 14
  description = "If not not null, a replay archive will be created"
}

variable "bus_log_retention_days_default" {
  type        = number
  default     = 14
  description = "If not not null, a log group and rule will be created"
}

variable "bus_logging_enabled_default" {
  type    = bool
  default = true
}

variable "bus_logging_excluded_detail_types_default" {
  type = list(string)
  default = [
    "AWS API Call via CloudTrail"
  ]
}

variable "monitor_data" {
  type = object({
    alert = object({
      topic_map = map(object({
        topic_arn = string
      }))
    })
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

variable "policy_access_list_default" {
  type = list(string)
  default = [
    "write",
  ]
}

variable "policy_create_default" {
  type    = bool
  default = true
}

variable "policy_name_append_default" {
  type    = string
  default = "bus"
}

variable "policy_name_prefix_default" {
  type    = string
  default = ""
}

variable "sid_condition_map_default" {
  type = map(object({
    test       = string
    value_list = list(string)
    variable   = string
  }))
  default = {}
}

variable "sid_identifier_list_default" {
  type    = list(string)
  default = ["*"]
}

variable "sid_identifier_type_default" {
  type    = string
  default = "*"
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
