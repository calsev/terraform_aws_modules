variable "param_map" {
  type = map(object({
    allowed_pattern    = optional(string)
    create_policy      = optional(bool)
    data_type          = optional(string)
    insecure_value     = string
    kms_key_id         = optional(string)
    overwrite          = optional(bool)
    policy_access_list = optional(list(string))
    policy_name        = optional(string) # Defaults to name-param
    policy_name_infix  = optional(bool)
    policy_name_prefix = optional(string)
    tier               = optional(string)
    type               = optional(string)
  }))
}

variable "param_allowed_pattern_default" {
  type    = string
  default = null
}

variable "param_create_policy_default" {
  type    = bool
  default = true
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

variable "param_policy_access_list_default" {
  type    = list(string)
  default = ["read"]
}

variable "param_policy_name_infix_default" {
  type    = bool
  default = true
}

variable "param_policy_name_prefix_default" {
  type    = string
  default = ""
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
