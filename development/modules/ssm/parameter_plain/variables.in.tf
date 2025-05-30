{{ name.var() }}

variable "param_map" {
  type = map(object({
    allowed_pattern         = optional(string)
    data_type               = optional(string)
    insecure_value          = string
    kms_key_id              = optional(string)
    {{ name.var_item() }}
    policy_access_list      = optional(list(string))
    policy_create           = optional(bool)
    policy_name_append      = optional(string)
    tier                    = optional(string)
    type                    = optional(string)
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

{{ iam.policy_var_ar(access=["read", "read_write"], append="param") }}

{{ std.map() }}
