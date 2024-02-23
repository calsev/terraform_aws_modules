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
    force_overwrite         = optional(bool)
    kms_key_id              = optional(string)
    name_include_app_fields = optional(bool)
    name_infix              = optional(bool)
    name_prefix             = optional(string)
    name_suffix             = optional(string)
    policy_access_list      = optional(list(string))
    policy_create           = optional(bool)
    policy_name             = optional(string)
    policy_name_append      = optional(string)
    policy_name_infix       = optional(bool)
    policy_name_prefix      = optional(string)
    policy_name_prepend     = optional(string)
    policy_name_suffix      = optional(string)
    recovery_window_days    = optional(string)
    resource_policy_json    = optional(string)
    secret_random_init_key  = optional(string)
    secret_random_init_map  = optional(map(string))
    secret_random_init_type = optional(string)
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

variable "secret_name_include_app_fields_default" {
  type    = bool
  default = true
}

variable "secret_name_infix_default" {
  type    = bool
  default = true
}

variable "secret_name_prefix_default" {
  type    = string
  default = ""
}

variable "secret_name_suffix_default" {
  type    = string
  default = ""
}

variable "secret_random_init_key_default" {
  type        = string
  default     = null
  description = "If provided, the initial value with be a map with the random secret at this key, otherwise the initial value will be the secret itself. Ignored for TLS keys."
}

variable "secret_random_init_map_default" {
  type        = map(string)
  default     = null
  description = "If provided, will be merged with the secret key, if provided"
}

variable "secret_random_init_type_default" {
  type        = string
  default     = null
  description = "This is false for backwards compatibility. See module secret/random for an initialized wrapper."
  validation {
    condition     = var.secret_random_init_type_default == null ? true : contains(["password", "tls_key"], var.secret_random_init_type_default)
    error_message = "Invalid random init type"
  }
}

variable "secret_random_init_value_map" {
  type        = map(string)
  description = "For each secret, if an initial value is provided, the secret will be initialized with that value, otherwise a random password."
  default     = {}
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
