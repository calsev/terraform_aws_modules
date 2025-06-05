{{ name.var() }}

variable "pool_map" {
  type = map(object({
    group_map = optional(map(object({
      iam_role_arn            = optional(string)
      {{ name.var_item() }}
      precedence              = optional(number)
    })))
    user_pool_id = string
  }))
}

variable "pool_group_map_default" {
  type = map(object({
    iam_role_arn  = optional(string)
    name_override = optional(string)
    precedence    = optional(number)
  }))
  default = {}
}

variable "pool_group_iam_role_arn_default" {
  type    = string
  default = null
}

variable "pool_group_precedence_default" {
  type    = number
  default = null
  validation {
    condition     = var.pool_group_precedence_default == null ? true : var.pool_group_precedence_default >= 0
    error_message = "Invalid group precedence"
  }
}

{{ std.map() }}
