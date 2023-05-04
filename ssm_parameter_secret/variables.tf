variable "param_map" {
  type = map(object({
    create_policy      = optional(bool)
    kms_key_id         = optional(string)
    policy_access_list = optional(list(string))
    policy_name        = optional(string) # Defaults to name-param
    policy_name_infix  = optional(bool)
    policy_name_prefix = optional(string)
    tier               = optional(string)
  }))
}

variable "param_create_policy_default" {
  type    = bool
  default = true
}

variable "param_kms_key_id_default" {
  type    = string
  default = "alias/aws/ssm"
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
