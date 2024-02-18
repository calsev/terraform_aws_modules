variable "param_map" {
  type = map(object({
    kms_key_id             = optional(string)
    policy_access_list     = optional(list(string))
    policy_create          = optional(bool)
    policy_name            = optional(string)
    policy_name_append     = optional(string)
    policy_name_infix      = optional(bool)
    policy_name_prefix     = optional(string)
    policy_name_prepend    = optional(string)
    policy_name_suffix     = optional(string)
    secret_random_init_key = optional(string)
    secret_random_init_map = optional(map(string))
    tier                   = optional(string)
  }))
}

variable "param_kms_key_id_default" {
  type    = string
  default = "alias/aws/ssm"
}

variable "param_secret_random_init_key_default" {
  type        = string
  default     = null
  description = "If provided, the initial value with be a map with the random secret at this key, otherwise the initial value will be the secret itself"
}

variable "param_secret_random_init_map_default" {
  type        = map(string)
  default     = null
  description = "If provided, will be merged with the secret key, if provided"
}

variable "param_tier_default" {
  type    = string
  default = "Standard"
  validation {
    condition     = contains(["Advanced", "Intelligent-Tiering", "Standard"], var.param_tier_default)
    error_message = "Invalid tier"
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
