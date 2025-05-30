variable "key_map" {
  type = map(object({
    {{ name.var_item() }}
    secret_is_param         = optional(bool)
  }))
}

variable "key_secret_is_param_default" {
  type    = bool
  default = false
}

{{ name.var() }}

{{ std.map() }}
