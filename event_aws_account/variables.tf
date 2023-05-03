variable "iam_data" {
  type = object({
    iam_policy_arn_batch_submit_job = string
    iam_policy_arn_ecs_start_task   = string
  })
}

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
  default = 3
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
