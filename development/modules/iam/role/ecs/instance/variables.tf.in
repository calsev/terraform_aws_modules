variable "max_session_duration_m" {
  type    = number
  default = null
}

variable "monitor_data" {
  type = object({
    ecs_ssm_param_map = object({
      cpu = object({
        policy_map = map(object({
          iam_policy_arn = string
        }))
      })
      gpu = object({
        policy_map = map(object({
          iam_policy_arn = string
        }))
      })
    })
  })
}

{{ name.var() }}

{{ iam.role_var() }}

{{ std.map() }}
