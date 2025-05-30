variable "allow_cloudtrail_default" {
  type    = bool
  default = true
}

variable "allow_iam_delegation_default" {
  type    = bool
  default = true
}

variable "key_map" {
  type = map(object({
    allow_cloudtrail                           = optional(bool)
    allow_iam_delegation                       = optional(bool)
    custom_key_store_id                        = optional(string)
    customer_master_key_spec                   = optional(string)
    deletion_window_days                       = optional(number)
    iam_policy_json                            = optional(string)
    is_enabled                                 = optional(bool)
    key_usage                                  = optional(string)
    multi_region_enabled                       = optional(bool)
    {{ name.var_item() }}
    policy_access_list                         = optional(list(string))
    policy_create                              = optional(bool)
    policy_lockout_safety_check_bypass_enabled = optional(bool)
    policy_name_append                         = optional(string)
    rotation_period_days                       = optional(number)
    xks_key_id                                 = optional(string)
  }))
}

variable "key_custom_key_store_id_default" {
  type    = string
  default = null
}

variable "key_customer_master_key_spec_default" {
  type    = string
  default = "SYMMETRIC_DEFAULT"
  validation {
    condition     = contains(["ECC_NIST_P256", "ECC_NIST_P384", "ECC_NIST_P521", "ECC_SECG_P256K1", "HMAC_256", "RSA_2048", "RSA_3072", "RSA_4096", "SYMMETRIC_DEFAULT"], var.key_customer_master_key_spec_default)
    error_message = "Invalid customer master key spec"
  }
}

variable "key_deletion_window_days_default" {
  type    = number
  default = 30
  validation {
    condition     = 7 <= var.key_deletion_window_days_default && var.key_deletion_window_days_default <= 30
    error_message = "Invalid deletion window days"
  }
}

variable "key_iam_policy_json_default" {
  type    = string
  default = null
}

variable "key_is_enabled_default" {
  type    = bool
  default = true
}

variable "key_key_usage_default" {
  type    = string
  default = "ENCRYPT_DECRYPT"
  validation {
    condition     = contains(["ENCRYPT_DECRYPT", "GENERATE_VERIFY_MAC", "SIGN_VERIFY"], var.key_key_usage_default)
    error_message = "Invalid key usage"
  }
}

variable "key_multi_region_enabled_default" {
  type    = bool
  default = false
}

variable "key_policy_lockout_safety_check_bypass_enabled_default" {
  type    = bool
  default = false
}

variable "key_rotation_period_days_default" {
  type        = number
  default     = 180
  description = "Set nonzero to enable rotation. A medium-severity security violation if disabled."
  validation {
    condition     = 90 <= var.key_rotation_period_days_default && var.key_rotation_period_days_default <= 2560
    error_message = "Invalid key usage"
  }
}

variable "key_xks_key_id_default" {
  type    = string
  default = null
}

{{ name.var() }}

{{ iam.policy_var_ar(access=["read_write"], append="key") }}

{{ std.map() }}
