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

{{ std.map() }}
