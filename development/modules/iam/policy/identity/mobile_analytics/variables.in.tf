variable "name" {
  type = string
}

{{ name.var() }}

{{ iam.policy_var_ar(access=["write"]) }}

{{ std.map() }}
