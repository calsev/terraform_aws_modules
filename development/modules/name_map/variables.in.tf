variable "name_map" {
  type = map(object({
    {{ name.var_item() }}
    name_override           = optional(string)
    tags                    = optional(map(string))
  }))
}

{{ name.var() }}

{{ std.map() }}

variable "tags_default" {
  type    = map(string)
  default = {}
}
