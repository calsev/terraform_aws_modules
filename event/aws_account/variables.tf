variable "archive_retention_days_for_default_bus" {
  type    = number
  default = 3
}

variable "logging_enabled_for_default_bus" {
  type    = bool
  default = true
}

variable "log_retention_days_for_default_bus" {
  type    = number
  default = 7
}

variable "alert_data_map" {
  type = object({
    topic_map = map(object({
      topic_arn = string
    }))
  })
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
