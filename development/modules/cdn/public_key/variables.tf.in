variable "key_map" {
  type = map(object({
    {{ name.var_item() }}
    policy_access_list      = optional(list(string))
    policy_create           = optional(bool)
    secret_is_param         = optional(bool)
  }))
}

variable "key_secret_is_param_default" {
  type    = bool
  default = false
}

{{ name.var(app_fields=False) }}

{{ iam.policy_var_ar() }}

{{ std.map() }}
