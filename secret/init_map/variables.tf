variable "secret_map" {
  type = map(object({
    secret_random_init     = optional(bool)
    secret_random_init_key = optional(string)
    secret_random_init_map = optional(map(string))
  }))
}

variable "secret_random_init_default" {
  type        = bool
  default     = true
  description = "If true, the secret will be initialized with a random value"
}

variable "secret_random_init_key_default" {
  type        = string
  default     = null
  description = "If provided, the initial value with be a map with the random secret at this key, otherwise the initial value will be the secret itself"
}

variable "secret_random_init_map_default" {
  type        = map(string)
  default     = null
  description = "If provided, will be merged with the secret key, if provided"
}
