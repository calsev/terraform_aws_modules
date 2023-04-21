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

variable "sns_topic_name" {
  type = string
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    iam_partition                  = string
    aws_account_id                 = string
    aws_region_name                = string
    iam_partition                  = string
    service_resource_access_action = map(map(map(list(string))))
  })
}
