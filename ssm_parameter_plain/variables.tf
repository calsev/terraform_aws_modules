variable "param_map" {
  type = map(object({
    allowed_pattern = optional(string)
    data_type       = optional(string)
    insecure_value  = string
    kms_key_id      = optional(string)
    overwrite       = optional(bool)
    tier            = optional(string)
    type            = optional(string)
  }))
}

variable "param_allowed_pattern_default" {
  type    = string
  default = null
}

variable "param_data_type_default" {
  type    = string
  default = "text"
  validation {
    condition     = contains(["aws:ec2:image", "aws:ssm:integration", "text"], var.param_data_type_default)
    error_message = "Invalid data type"
  }
}

variable "param_kms_key_id_default" {
  type    = string
  default = null
}

variable "param_overwrite_default" {
  type    = bool
  default = true
}

variable "param_tier_default" {
  type    = string
  default = "Standard"
  validation {
    condition     = contains(["Advanced", "Intelligent-Tiering", "Standard"], var.param_tier_default)
    error_message = "Invalid tier"
  }
}

variable "param_type_default" {
  type    = string
  default = "String"
  validation {
    condition     = contains(["String", "StringList"], var.param_type_default)
    error_message = "Invalid type"
  }
}

variable "std_map" {
  type = object({
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
