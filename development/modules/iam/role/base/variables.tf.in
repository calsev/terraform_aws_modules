variable "assume_role_account_map" {
  type = map(object({
    aws_account_id_list = list(string)
    external_id_list    = optional(list(string), [])
  }))
  default = {}
}

variable "assume_role_json" {
  type    = string
  default = null
}

variable "assume_role_service_list" {
  type    = list(string)
  default = []
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
    {{ iam.role_var_item() }}
  })
  default = {
    {{ iam.role_var_item(type="null") }}
  }
}

variable "max_session_duration_m" {
  type    = number
  default = null
}

{{ name.var_singular() }}

{{ iam.role_var() }}

{{ std.map() }}
