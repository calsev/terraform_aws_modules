variable "assume_role_json" {
  type    = string
  default = null
}

variable "assume_role_service_list" {
  type    = list(string)
  default = null
}

variable "create_instance_profile" {
  type    = bool
  default = false
}

variable "embedded_role_policy_attach_arn_map" {
  type = map(object({
    condition = optional(bool, true)
    policy    = string
  }))
  default = {}
}

variable "embedded_role_policy_create_json_map" {
  type = map(object({
    condition = optional(bool, true)
    policy    = string
  }))
  default = {}
}

variable "embedded_role_policy_inline_json_map" {
  type = map(object({
    condition = optional(bool, true)
    policy    = string
  }))
  default = {}
}

variable "embedded_role_policy_managed_name_map" {
  type = map(object({
    condition = optional(bool, true)
    policy    = string
  }))
  default = {}
}

variable "map_policy" {
  type = object({
    role_policy_attach_arn_map   = map(string)
    role_policy_create_json_map  = map(string)
    role_policy_inline_json_map  = map(string)
    role_policy_managed_name_map = map(string)
  })
  default = null
}

variable "max_session_duration_m" {
  type    = number
  default = null
}

variable "name" {
  type = string
}

variable "name_include_app_fields" {
  type        = bool
  default     = true
  description = "If true, standard resource prefix will be applied to the role"
}

variable "name_infix" {
  type        = bool
  default     = true
  description = "If true, standard resource prefix and suffix will be applied to the role"
}

variable "name_prefix" {
  type        = string
  default     = ""
  description = "If provided, will be put in front of the standard prefix for the role name."
}

variable "role_policy_attach_arn_map_default" {
  type    = map(string)
  default = {}
}

variable "role_policy_create_json_map_default" {
  type    = map(string)
  default = {}
}

variable "role_policy_inline_json_map_default" {
  type    = map(string)
  default = null
}

variable "role_policy_managed_name_map_default" {
  type        = map(string)
  default     = null
  description = "The short identifier of the managed policy, the part after 'arn:<iam_partition>:iam::aws:policy/'"
}

variable "role_path" {
  type    = string
  default = null
}

variable "std_map" {
  type = object({
    iam_partition        = string
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
