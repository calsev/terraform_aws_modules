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
    {{ iam.role_var_item() }}
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

{{ iam.role_var() }}
