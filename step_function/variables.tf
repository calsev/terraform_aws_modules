variable "machine_map" {
  type = map(object({
    definition_json = string
    iam_role_arn    = optional(string)
    log_data = object({
      log_group_arn = string
    })
    log_level           = optional(string)
    name_infix          = optional(bool)
    policy_access_list  = optional(list(string))
    policy_create       = optional(bool)
    policy_name         = optional(string)
    policy_name_append  = optional(string)
    policy_name_infix   = optional(bool)
    policy_name_prefix  = optional(string)
    policy_name_prepend = optional(string)
    policy_name_suffix  = optional(string)
  }))
}

variable "machine_iam_role_arn_default" {
  type    = string
  default = null
}

variable "machine_log_level_default" {
  type    = string
  default = "ERROR"
  validation {
    condition     = contains(["ALL", "ERROR", "FATAL", "OFF"], var.machine_log_level_default)
    error_message = "Invalid log level"
  }
}

variable "machine_name_infix_default" {
  type    = bool
  default = true
}

variable "policy_access_list_default" {
  type    = list(string)
  default = ["write"]
}

variable "policy_create_default" {
  type    = bool
  default = true
}

variable "policy_name_append_default" {
  type    = string
  default = ""
}

variable "policy_name_infix_default" {
  type    = bool
  default = true
}

variable "policy_name_prefix_default" {
  type    = string
  default = ""
}

variable "policy_name_prepend_default" {
  type    = string
  default = "start"
}

variable "policy_name_suffix_default" {
  type    = string
  default = ""
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
