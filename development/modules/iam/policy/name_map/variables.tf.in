variable "name_map" {
  type = map(object({
    policy_create                  = optional(bool)
    policy_access_list             = optional(list(string))
    policy_name_append             = optional(string)
    policy_name_include_app_fields = optional(bool)
    policy_name_infix              = optional(bool)
    policy_name_override           = optional(string)
    policy_name_prefix             = optional(string)
    policy_name_prepend            = optional(string)
    policy_name_suffix             = optional(string)
  }))
}

{{ iam.policy_var_ar() }}

# tflint-ignore: terraform_unused_declarations
{{ std.map() }}
