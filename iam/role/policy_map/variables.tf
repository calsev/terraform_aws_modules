variable "role_map" {
  type = map(object({
    embedded_role_policy_attach_arn_map = optional(map(object({
      condition = optional(bool, true)
      policy    = string
    })))
    embedded_role_policy_create_json_map = optional(map(object({
      condition = optional(bool, true)
      policy    = string
    })))
    embedded_role_policy_inline_json_map = optional(map(object({
      condition = optional(bool, true)
      policy    = string
    })))
    embedded_role_policy_managed_name_map = optional(map(object({
      condition = optional(bool, true)
      policy    = string
    })))
    role_policy_attach_arn_map   = optional(map(string))
    role_policy_create_json_map  = optional(map(string))
    role_policy_inline_json_map  = optional(map(string))
    role_policy_managed_name_map = optional(map(string))
    role_path                    = optional(string)
  }))
}

variable "embedded_role_policy_attach_arn_map_default" {
  type = map(object({
    condition = optional(bool, true)
    policy    = string
  }))
  default = {}
}

variable "embedded_role_policy_create_json_map_default" {
  type = map(object({
    condition = optional(bool, true)
    policy    = string
  }))
  default = {}
}

variable "embedded_role_policy_inline_json_map_default" {
  type = map(object({
    condition = optional(bool, true)
    policy    = string
  }))
  default = {}
}

variable "embedded_role_policy_managed_name_map_default" {
  type = map(object({
    condition = optional(bool, true)
    policy    = string
  }))
  default = {}
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
  default = {}
}

variable "role_policy_managed_name_map_default" {
  type        = map(string)
  default     = {}
  description = "The short identifier of the managed policy, the part after 'arn:<iam_partition>:iam::aws:policy/'"
}

variable "role_path_default" {
  type    = string
  default = null
}
