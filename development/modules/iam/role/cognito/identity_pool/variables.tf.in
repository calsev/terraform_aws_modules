variable "cognito_data_map" {
  type = map(object({
    identity_pool_id = string
  }))
}

variable "identity_pool_key" {
  type = string
}

variable "is_authenticated" {
  type    = bool
  default = true
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
