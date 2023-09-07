variable "role_map" {
  type = map(object({
    embedded_role_policy_attach_arn_map = optional(map(object({
      condition = bool
      policy    = string
    })))
    embedded_role_policy_create_json_map = optional(map(object({
      condition = bool
      policy    = string
    })))
    embedded_role_policy_inline_json_map = optional(map(object({
      condition = bool
      policy    = string
    })))
    embedded_role_policy_managed_name_map = optional(map(object({
      condition = bool
      policy    = string
    })))
    role_policy_attach_arn_map   = optional(map(string))
    role_policy_create_json_map  = optional(map(string))
    role_policy_inline_json_map  = optional(map(string))
    role_policy_managed_name_map = optional(map(string))
  }))
}

variable "embedded_role_policy_attach_arn_map_default" {
  type = map(object({
    condition = bool
    value     = string
  }))
  default = {}
}

variable "embedded_role_policy_create_json_map_default" {
  type = map(object({
    condition = bool
    value     = string
  }))
  default = {}
}

variable "embedded_role_policy_inline_json_map_default" {
  type = map(object({
    condition = bool
    value     = string
  }))
  default = {}
}

variable "embedded_role_policy_managed_name_map_default" {
  type = map(object({
    condition = bool
    value     = string
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
  type    = map(string)
  default = {}
}
