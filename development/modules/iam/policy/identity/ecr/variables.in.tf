{{ name.var() }}

# Typically building the image will involve reading layers as well
{{ iam.policy_var_ar(access=["read", "read_write"]) }}

variable "policy_map" {
  type = map(object({
    access_list             = optional(list(string))
    {{ name.var_item() }}
    policy_create           = optional(bool)
    policy_name_append      = optional(string)
    repo_name               = string
  }))
}

{{ std.map() }}
