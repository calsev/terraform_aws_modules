variable "build_name_list" {
  type = list(string)
}

variable "deploy_group_to_app" {
  type = map(string)
}

variable "ci_cd_account_data" {
  type = object({
    bucket = object({
      policy = object({
        policy_map = map(object({
          iam_policy_arn = string
        }))
      })
    })
    code_star = object({
      connection = map(object({
        connection_arn = string
        policy_map = map(object({
          iam_policy_arn = string
        }))
      }))
    })
  })
}

variable "code_star_connection_key" {
  type = string
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

{{ iam.policy_var_ar(access=["read_write"], append="build") }}

{{ iam.role_var() }}

{{ std.map() }}
