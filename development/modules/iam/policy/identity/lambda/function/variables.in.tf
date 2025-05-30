{{ name.var() }}

{{ iam.policy_var_ar(access=["write"]) }}

variable "policy_map" {
  type = map(object({
    access_list             = optional(list(string))
    function_name_list      = list(string)
    {{ name.var_item() }}
    policy_create           = optional(bool)
    policy_name_append      = optional(string)
  }))
}

{{ std.map() }}
