{{ name.var() }}

{{ iam.policy_var_ar(access=["read", "write"]) }}

variable "policy_map" {
  type = map(object({
    {{ name.var_item() }}
    {{ iam.policy_var_item() }}
    sns_topic_name              = string
  }))
}

{{ std.map() }}
