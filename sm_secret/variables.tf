variable "policy_access_list_default" {
  type    = list(string)
  default = ["read"]
}

variable "policy_create_default" {
  type    = bool
  default = true
}

variable "policy_name_append_default" {
  type    = string
  default = "secret"
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

variable "secret_map" {
  type = map(object({
    force_overwrite      = optional(bool)
    kms_key_id           = optional(string)
    policy_access_list   = optional(list(string))
    policy_create        = optional(bool)
    policy_name          = optional(string)
    policy_name_append   = optional(string)
    policy_name_infix    = optional(bool)
    policy_name_prefix   = optional(string)
    policy_name_prepend  = optional(string)
    policy_name_suffix   = optional(string)
    recovery_window_days = optional(string)
    resource_policy_json = optional(string)
  }))
}

variable "secret_force_overwrite_default" {
  type    = bool
  default = false
}

variable "secret_kms_key_id_default" {
  type    = string
  default = null
}

variable "secret_recovery_window_days_default" {
  type        = number
  default     = 30
  description = "Set to 0 to force delete"
}

variable "secret_resource_policy_json_default" {
  type    = string
  default = "{}"
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
