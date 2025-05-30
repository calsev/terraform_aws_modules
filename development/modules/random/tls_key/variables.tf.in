variable "key_map" {
  type = map(object({
    algorithm   = optional(string)
    ecdsa_curve = optional(number)
    rsa_bits    = optional(number)
  }))
}

variable "key_algorithm_default" {
  type    = string
  default = "RSA"
  validation {
    condition     = contains(["RSA", "ECDSA", "ED25519"], var.key_algorithm_default)
    error_message = "Invalid algorithm"
  }
}

variable "key_ecdsa_curve_default" {
  type        = string
  default     = "P224"
  description = "Ignored unless the algorithm is ECDSA"
  validation {
    condition     = contains(["P224", "P256", "P384", "P521"], var.key_ecdsa_curve_default)
    error_message = "Invalid curve"
  }
}

variable "key_rsa_bits_default" {
  type        = number
  default     = 2048
  description = "Ignored unless the algorithm is RSA"
}
