variable "param_map" {
  type = map(object({
    kms_key_id = optional(string)
    tier       = optional(string)
  }))
}

variable "param_kms_key_id_default" {
  type    = string
  default = "alias/aws/ssm"
}

variable "param_tier_default" {
  type    = string
  default = "Standard"
  validation {
    condition     = contains(["Advanced", "Intelligent-Tiering", "Standard"], var.param_tier_default)
    error_message = "Invalid tier"
  }
}

variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
