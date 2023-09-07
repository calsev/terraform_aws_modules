variable "param_map" {
  type = map(object({
    allowed_pattern     = optional(string)
    data_type           = optional(string)
    insecure_value      = string
    kms_key_id          = optional(string)
    overwrite           = optional(bool)
    policy_access_list  = optional(list(string))
    policy_create       = optional(bool)
    policy_name         = optional(string)
    policy_name_append  = optional(string)
    policy_name_infix   = optional(bool)
    policy_name_prefix  = optional(string)
    policy_name_prepend = optional(string)
    policy_name_suffix  = optional(string)
    tier                = optional(string)
    type                = optional(string)
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
