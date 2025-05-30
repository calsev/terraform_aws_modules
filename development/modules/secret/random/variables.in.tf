{{ name.var() }}

{{ iam.policy_var_ar(access=["read", "read_write"], append="secret") }}

variable "secret_map" {
  type = map(object({
    {{ name.var_item() }}
    {{ iam.policy_var_item() }}
    secret_is_param         = optional(bool)
    secret_random_init_key  = optional(string)
    secret_random_init_map  = optional(map(string))
    secret_random_init_type = optional(string)
  }))
}

variable "secret_is_param_default" {
  type    = bool
  default = false
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
  type    = string
  default = "password"
  validation {
    condition     = var.secret_random_init_type_default == null ? true : contains(["password", "ssh_key", "tls_key"], var.secret_random_init_type_default)
    error_message = "Invalid random init type"
  }
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

{{ std.map() }}
