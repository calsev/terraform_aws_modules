{{ name.var() }}

{{ iam.policy_var_ar() }}

variable "policy_map" {
  type = map(object({
    access_list             = optional(list(string))
    {{ name.var_item() }}
    policy_create           = optional(bool)
    policy_name_append      = optional(string)
    resource_map            = map(list(string)) # A map of resource type to resource names
    service_name            = optional(string)
  }))
}

variable "policy_service_name_default" {
  type    = string
  default = null
}

{{ std.map() }}
