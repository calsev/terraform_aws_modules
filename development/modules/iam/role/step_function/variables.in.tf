variable "log_data" {
  type = object({
    iam_policy_arn_map = object({
      read  = string
      write = string
    })
  })
}

variable "map_policy" {
  type = object({
    {{ iam.role_var_item() }}
  })
  default = {
    {{ iam.role_var_item(type="null") }}
  }
}

variable "max_session_duration_m" {
  type    = number
  default = null
}

variable "name" {
  type = string
}

{{ name.var() }}

{{ iam.role_var() }}

{{ std.map() }}
