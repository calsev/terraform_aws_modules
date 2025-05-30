variable "iam_data" {
  type = object({
    iam_policy_arn_ecs_exec_ssm = string
  })
  default     = null
  description = "Must be provided if ecs_exec_enabled"
}

variable "ecs_exec_enabled" {
  type    = bool
  default = false
}

variable "log_data" {
  type = object({
    policy_map = map(object({
      iam_policy_arn = string
    }))
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
