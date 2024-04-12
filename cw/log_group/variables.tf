variable "log_map" {
  type = map(object({
    allow_public_read   = optional(bool)
    kms_key_id          = optional(string)
    log_group_class     = optional(string)
    log_retention_days  = optional(number)
    name_prefix         = optional(string)
    policy_access_list  = optional(list(string))
    policy_create       = optional(bool)
    policy_name         = optional(string)
    policy_name_append  = optional(string)
    policy_name_infix   = optional(bool)
    policy_name_prefix  = optional(string)
    policy_name_prepend = optional(string)
    policy_name_suffix  = optional(string)
    skip_destroy        = optional(bool)
  }))
}

variable "log_allow_public_read_default" {
  type    = bool
  default = false
}

variable "log_group_class_default" {
  type    = string
  default = "STANDARD"
  validation {
    condition     = contains(["INFREQUENT_ACCESS", "STANDARD"], var.log_group_class_default)
    error_message = "Invalid log group class"
  }
}

variable "log_kms_key_id_default" {
  type    = string
  default = null
}

variable "log_retention_days_default" {
  type    = number
  default = 14
  validation {
    condition     = contains([0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.log_retention_days_default)
    error_message = "Log retention must be one of a set of allowed values"
  }
}

variable "log_name_prefix_default" {
  type    = string
  default = ""
}

variable "log_skip_destroy_default" {
  type    = bool
  default = false
}

variable "policy_access_list_default" {
  type    = list(string)
  default = ["read", "write"]
}

variable "policy_create_default" {
  type    = bool
  default = true
}

variable "policy_name_append_default" {
  type    = string
  default = "log"
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
