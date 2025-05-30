variable "connection_map" {
  type = map(object({
    host_key      = optional(string)
    name_override = optional(string) # This is for imported connections
    provider_type = optional(string)
  }))
  description = "These are created in pending state and authorized by whomever does it. Therefore they are linked to the permissions for a user."
}

variable "connection_host_key_default" {
  type    = string
  default = null
}

variable "connection_provider_type_default" {
  type    = string
  default = "GitHub"
}

variable "host_data_map" {
  type = map(object({
    host_arn = string
  }))
}

# Name is limited to 32 chars
{{ name.var(infix=False, app_fields=False) }}

{{ iam.policy_var_ar(access=["read", "read_write"], append="code_connection") }}

{{ std.map() }}
