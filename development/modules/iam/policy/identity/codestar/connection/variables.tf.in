{{ name.var() }}

{{ iam.policy_var_ar(access=["read", "read_write"]) }}

variable "policy_map" {
  type = map(object({
    access_list             = optional(list(string))
    connection_arn          = optional(string) # If provided, the policy will be specific to the connection, otherwise generic
    connection_host_arn     = optional(string) # If provided, the policy will include permissions for the host
    {{ name.var_item() }}
    policy_create           = optional(bool)
    policy_name_append      = optional(string)
  }))
}

{{ std.map() }}
