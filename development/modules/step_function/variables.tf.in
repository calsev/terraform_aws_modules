variable "machine_map" {
  type = map(object({
    definition_json              = string
    log_level                    = optional(string)
    {{ name.var_item() }}
    policy_access_list           = optional(list(string))
    policy_create                = optional(bool)
    policy_name_append           = optional(string)
    {{ iam.role_var_item() }}
  }))
}

variable "machine_log_level_default" {
  type    = string
  default = "ERROR"
  validation {
    condition     = contains(["ALL", "ERROR", "FATAL", "OFF"], var.machine_log_level_default)
    error_message = "Invalid log level"
  }
}

{{ name.var() }}

{{ iam.policy_var_ar(access=["write"]) }}

{{ iam.role_var() }}

{{ std.map() }}
