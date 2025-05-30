variable "iam_data" {
  type = object({
    iam_policy_arn_lambda_vpc = string
  })
  default     = null
  description = "Must be provided if any secret is configured with rotation_method"
}

variable "secret_data_map" {
  type = map(object({
    policy_map = map(object({
      iam_policy_arn = string
    }))
    secret_id = string
  }))
}

variable "rotation_map" {
  type = map(object({
    {{ name.var_item() }}
    rotate_immediately                                 = optional(bool)
    rotation_lambda_arn                                = optional(string)
    rotation_method                                    = optional(string)
    rotation_schedule_days                             = optional(number)
    rotation_schedule_expression                       = optional(string)
    rotation_schedule_window                           = optional(string)
    rotation_value_random_string_characters_to_exclude = optional(string)
    rotation_value_random_string_length                = optional(number)
    rotation_value_key_to_replace                      = optional(string)
    rotation_value_list_max_length                     = optional(number)
    secret_key                                         = optional(string) # Defaults to key
    vpc_az_key_list                                    = optional(list(string))
    vpc_ipv6_allowed                                   = optional(bool)
    vpc_key                                            = optional(string)
    vpc_security_group_key_list                        = optional(list(string))
    vpc_segment_key                                    = optional(string)
  }))
}

{{ name.var() }}

variable "rotation_rotate_immediately_default" {
  type    = bool
  default = true
}

variable "rotation_lambda_arn_default" {
  type    = string
  default = null
}

variable "rotation_method_default" {
  type        = string
  default     = null
  description = "Ignored if rotation_lambda_arn is specified"
  validation {
    condition     = contains(["rotate_whole_string", "rotate_key_value", "rotate_key_value_list_newest_first"], var.rotation_method_default)
    error_message = "Invalid rotation method"
  }
}

variable "rotation_schedule_days_default" {
  type        = number
  default     = null
  description = "Exactly one of rotation_schedule_days and rotation_schedule_window must be specified"
}

variable "rotation_schedule_expression_default" {
  type        = string
  default     = null
  description = "Exactly one of rotation_schedule_days and rotation_schedule_window must be specified"
}

variable "rotation_schedule_window_default" {
  type    = string
  default = null
}

variable "rotation_value_random_string_characters_to_exclude_default" {
  type    = string
  default = ""
}

variable "rotation_value_random_string_length_default" {
  type    = number
  default = 32
}

variable "rotation_value_key_to_replace_default" {
  type        = string
  default     = ""
  description = "The key to replace in a key-value secret. Ignored for non-key-based rotation_method"
}

variable "rotation_value_list_max_length_default" {
  type        = number
  default     = null
  description = "The number of list entries to keep. Ignored for non-list-based rotation_method"
}

{{ std.map() }}

variable "vpc_az_key_list_default" {
  type    = list(string)
  default = ["a", "b"]
}

variable "vpc_data_map" {
  type = map(object({
    security_group_id_map = map(string)
    segment_map = map(object({
      route_public  = bool
      subnet_id_map = map(string)
    }))
    vpc_id = string
  }))
  default     = null
  description = "Must be provided if any function is configured in a VPC"
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "vpc_security_group_key_list_default" {
  type    = list(string)
  default = ["world_all_out"]
}

variable "vpc_segment_key_default" {
  type    = string
  default = "internal"
}
