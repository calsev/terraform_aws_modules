{{ name.var() }}


{{ iam.policy_var_ar(access=["read_write"], append="dynamodb") }}

variable "policy_map" {
  type = map(object({
    access_list             = optional(list(string))
    {{ name.var_item() }}
    name_map_table = map(object({
      name_list_index = optional(list(string), [])
    }))
    policy_create      = optional(bool)
    policy_name_append = optional(string)
  }))
}

{{ std.map() }}
