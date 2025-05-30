variable "allow_access_point" {
  type    = bool
  default = true
}

variable "allow_config_recording" {
  type    = bool
  default = false
}

variable "allow_insecure_access" {
  type    = bool
  default = false
}

variable "allow_log_cloudtrail" {
  type    = bool
  default = false
}

variable "allow_log_elb" {
  type    = bool
  default = false
}

variable "allow_log_waf" {
  type    = bool
  default = false
}

variable "allow_public" {
  type    = bool
  default = false
}

variable "bucket_name" {
  type = string
}

variable "policy_create" {
  type    = bool
  default = true
}

variable "sid_map" {
  type = map(object({
    access = string
    condition_map = optional(map(object({
      test       = string
      value_list = list(string)
      variable   = string
    })))
    identifier_list = optional(list(string))
    identifier_type = optional(string)
    object_key_list = optional(list(string))
  }))
}

variable "sid_identifier_list_default" {
  type    = list(string)
  default = ["*"]
}

variable "sid_identifier_type_default" {
  type    = string
  default = "*"
}

variable "sid_object_key_list_default" {
  type    = list(string)
  default = ["*"]
}

{{ std.map() }}
