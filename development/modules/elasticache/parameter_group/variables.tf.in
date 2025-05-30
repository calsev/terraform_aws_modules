variable "group_map" {
  type = map(object({
    family                  = optional(string)
    {{ name.var_item() }}
    parameter_map           = optional(map(string))
  }))
}

variable "group_family_default" {
  type    = string
  default = "redis7"
}

variable "group_parameter_map_default" {
  type    = map(string)
  default = {}
}

{{ name.var() }}

{{ std.map() }}
