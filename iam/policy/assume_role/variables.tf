variable "account_map" {
  type = map(object({
    aws_account_id_list = list(string)
    external_id_list    = optional(list(string), [])
  }))
  default = {}
}

variable "service_list" {
  type        = list(string)
  default     = []
  description = "Statements will be synthesized for these services"
}

variable "sid_map" {
  type = map(object({
    condition_map = optional(map(object({
      test       = string
      value_list = list(string)
      variable   = string
    })))
    identifier_list = optional(list(string))
    identifier_type = optional(string)
  }))
  default     = {}
  description = "A map of SID to statement. AssumeRole will be appended to the SID."
}

variable "sid_identifier_list_default" {
  type    = list(string)
  default = ["*"]
}

variable "sid_identifier_type_default" {
  type    = string
  default = "AWS"
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    config_name                    = string
    env                            = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
