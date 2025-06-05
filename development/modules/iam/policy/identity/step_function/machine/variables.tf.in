{{ name.var() }}

variable "policy_map" {
  type = map(object({
    machine_name              = string
    {{ name.var_item() }}
    {{ iam.policy_var_item() }}
  }))
}

{{ iam.policy_var_ar(access=["write"]) }}

{{ std.map() }}
