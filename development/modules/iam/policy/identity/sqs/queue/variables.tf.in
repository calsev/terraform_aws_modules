{{ name.var() }}

variable "policy_map" {
  type = map(object({
    {{ name.var_item() }}
    {{ iam.policy_var_item() }}
    queue_name              = string
  }))
}

{{ iam.policy_var_ar(access=["read", "write"], append="queue") }}

{{ std.map() }}
