variable "group_map" {
  type = map(object({
    key_key_list            = list(string)
    {{ name.var_item() }}
  }))
}

variable "key_data_map" {
  type = map(object({
    key_id = string
  }))
}

{{ name.var(app_fields=False) }}

{{ std.map() }}
