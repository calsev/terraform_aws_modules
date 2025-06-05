{{ name.var() }}

variable "policy_map" {
  type = map(object({
    key_arn_list              = list(string)
    {{ name.var_item() }}
    {{ iam.policy_var_item() }}
  }))
}

{{ iam.policy_var_ar(access=["read_write"]) }}

{{ std.map() }}
