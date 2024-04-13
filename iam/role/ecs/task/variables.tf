variable "log_data" {
  type = object({
    iam_policy_arn_map = object({
      write = string
    })
  })
}

variable "map_policy" {
  type = object({
    role_policy_attach_arn_map   = optional(map(string))
    role_policy_create_json_map  = optional(map(string))
    role_policy_inline_json_map  = optional(map(string))
    role_policy_managed_name_map = optional(map(string))
  })
  default = {
    role_policy_attach_arn_map   = null
    role_policy_create_json_map  = null
    role_policy_inline_json_map  = null
    role_policy_managed_name_map = null
  }
}

variable "max_session_duration_m" {
  type    = number
  default = null
}

variable "name" {
  type = string
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
  type        = map(string)
  default     = {}
  description = "The special sauce for the role; log write comes free"
}

variable "role_policy_create_json_map_default" {
  type    = map(string)
  default = {}
}

variable "role_policy_inline_json_map_default" {
  type    = map(string)
  default = {}
}

variable "role_policy_managed_name_map_default" {
  type        = map(string)
  default     = {}
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
