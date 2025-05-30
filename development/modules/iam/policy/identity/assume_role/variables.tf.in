{{ name.var() }}

{{ iam.policy_var_base() }}

variable "policy_map" {
  type = map(object({
    iam_role_arn_list       = list(string)
    {{ name.var_item() }}
    policy_create           = optional(bool)
    policy_name_append      = optional(string)
  }))
}

{{ std.map() }}
