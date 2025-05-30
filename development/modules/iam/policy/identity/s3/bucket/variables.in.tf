{{ name.var() }}

variable "policy_map" {
  type = map(object({
    {{ name.var_item() }}
    policy_create           = optional(bool)
    policy_name_append      = optional(string)
    sid_map = map(object({
      access           = string
      bucket_name_list = list(string) # Can be bucket names, bucket ARNs, access point ARNs
      object_key_list  = optional(list(string))
    }))
  }))
}

{{ iam.policy_var_base() }}

variable "sid_object_key_list_default" {
  type    = list(string)
  default = ["*"]
}

{{ std.map() }}
