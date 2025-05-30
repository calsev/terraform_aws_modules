{{ name.var() }}

{{ iam.policy_var_ar(access=["write"]) }}

variable "policy_map" {
  type = map(object({
    access_list             = optional(list(string))
    build_project_name_list = optional(list(string)) # If provided, the policy will be specific to reports for this group, otherwise it will be generic
    {{ name.var_item() }}
    policy_create           = optional(bool)
    policy_name_append      = optional(string)
  }))
}

{{ std.map() }}
