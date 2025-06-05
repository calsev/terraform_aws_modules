{{ name.var() }}

variable "policy_map" {
  type = map(object({
    iam_policy_json         = string
    {{ name.var_item() }}
    policy_create           = optional(bool)
    policy_name_append      = optional(string)
  }))
}

{{ iam.policy_var_base() }}

{{ std.map() }}
