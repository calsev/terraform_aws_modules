variable "bus_map" {
  type = map(object({
    archive_retention_days        = optional(number)
    event_bus_name                = optional(string) # "If provided, a bus will not be created
    logging_enabled               = optional(bool)
    logging_excluded_detail_types = optional(list(string))
    log_retention_days            = optional(number)
    policy_access_list            = optional(list(string))
    policy_create                 = optional(bool)
    policy_name                   = optional(string)
    policy_name_append            = optional(string)
    policy_name_infix             = optional(bool)
    policy_name_prefix            = optional(string)
    policy_name_prepend           = optional(string)
    policy_name_suffix            = optional(string)
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
  default = "bus"
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
  default = ""
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
