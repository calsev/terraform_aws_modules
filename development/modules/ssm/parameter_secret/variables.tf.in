{{ name.var() }}

variable "param_map" {
  type = map(object({
    kms_key_id              = optional(string)
    {{ name.var_item() }}
    policy_access_list      = optional(list(string))
    policy_create           = optional(bool)
    policy_name_append      = optional(string)
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

{{ iam.policy_var_ar(access=["read", "read_write"], append="param") }}

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

{{ std.map() }}
