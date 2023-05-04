variable "secret_map" {
  type = map(object({
    create_policy        = optional(bool)
    force_overwrite      = optional(bool)
    kms_key_id           = optional(string)
    policy_access_list   = optional(list(string))
    policy_name          = optional(string) # Defaults to name-secret
    policy_name_infix    = optional(bool)
    policy_name_prefix   = optional(string)
    recovery_window_days = optional(string)
    resource_policy_json = optional(string)
  }))
}

variable "secret_create_policy_default" {
  type    = bool
  default = true
}

variable "secret_force_overwrite_default" {
  type    = bool
  default = false
}

variable "secret_kms_key_id_default" {
  type    = string
  default = null
}

variable "secret_policy_access_list_default" {
  type    = list(string)
  default = ["read"]
}

variable "secret_policy_name_infix_default" {
  type    = bool
  default = true
}

variable "secret_policy_name_prefix_default" {
  type    = string
  default = ""
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
