variable "name_append_default" {
  type        = string
  default     = ""
  description = "Appended after key"
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = true
  description = "If true, the Terraform project context will be included in the name"
}

variable "name_infix_default" {
  type    = bool
  default = true
}

variable "name_prefix_default" {
  type        = string
  default     = ""
  description = "Prepended before context prefix"
}

variable "name_prepend_default" {
  type        = string
  default     = ""
  description = "Prepended after key"
}

variable "name_suffix_default" {
  type        = string
  default     = ""
  description = "Appended after context suffix"
}

variable "param_map" {
  type = map(object({
    kms_key_id              = optional(string)
    name_append             = optional(string)
    name_include_app_fields = optional(bool)
    name_infix              = optional(bool)
    name_prefix             = optional(string)
    name_prepend            = optional(string)
    name_suffix             = optional(string)
    policy_access_list      = optional(list(string))
    policy_create           = optional(bool)
    policy_name             = optional(string)
    policy_name_append      = optional(string)
    policy_name_infix       = optional(bool)
    policy_name_prefix      = optional(string)
    policy_name_prepend     = optional(string)
    policy_name_suffix      = optional(string)
    secret_random_init_key  = optional(string)
    secret_random_init_map  = optional(map(string))
    secret_random_init_type = optional(string)
    tier                    = optional(string)
  }))
}

variable "param_kms_key_id_default" {
  type    = string
  default = "alias/aws/ssm"
}

variable "param_secret_random_init_key_default" {
  type        = string
  default     = null
  description = "If provided, the initial value with be a map with the random secret at this key, otherwise the initial value will be the secret itself. Ignored for TLS keys."
}

variable "param_secret_random_init_map_default" {
  type        = map(string)
  default     = null
  description = "If provided, will be merged with the secret key, if provided"
}

variable "param_secret_random_init_type_default" {
  type    = string
  default = "password"
  validation {
    condition     = contains([null, "password", "ssh_key", "tls_key"], var.param_secret_random_init_type_default)
    error_message = "Invalid random init type"
  }
}

variable "param_tier_default" {
  type    = string
  default = "Standard"
  validation {
    condition     = contains(["Advanced", "Intelligent-Tiering", "Standard"], var.param_tier_default)
    error_message = "Invalid tier"
  }
}

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
  default = "param"
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

variable "secret_random_init_value_map" {
  type        = map(string)
  description = "For each secret, if an initial value is provided, the secret will be initialized with that value, otherwise a random password."
  default     = {}
}

variable "secret_random_special_character_set_default" {
  type        = string
  default     = "!@#$%&*()-_=+[]{}<>:?"
  description = "Has no effect unless a secret is a password"
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
