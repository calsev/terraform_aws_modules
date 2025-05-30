{{ name.var() }}

{{ iam.policy_var_ar(append="efs") }}

variable "policy_map" {
  type = map(object({
    access_list             = optional(list(string))
    efs_arn                 = string
    {{ name.var_item() }}
    policy_create           = optional(bool)
    policy_name_append      = optional(string)
  }))
}

{{ std.map() }}
