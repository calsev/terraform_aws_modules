variable "secret_map" {
  type = map(object({
    has_random_init_value               = bool
    secret_random_init_key              = string
    secret_random_init_map              = map(string)
    secret_random_init_type_is_password = bool
    secret_random_init_type_is_tls_key  = bool
  }))
}

variable "secret_random_init_value_map" {
  type        = map(string)
  description = "For each secret, if an initial value is provided, the secret will be initialized with that value, otherwise a random password."
  default     = {}
}