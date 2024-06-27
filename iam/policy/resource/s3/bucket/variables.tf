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

variable "allow_public" {
  type    = bool
  default = false
}

variable "allow_service_logging" {
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

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    iam_partition                  = string
    service_resource_access_action = map(map(map(list(string))))
  })
}
