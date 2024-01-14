variable "alert_map" {
  type = map(object({
    alert_enabled            = optional(bool)
    alert_event_pattern_json = string
    alert_level              = optional(string)
    alert_target_path_map    = map(string)
    alert_target_template    = string
  }))
}

variable "alert_enabled_default" {
  type    = bool
  default = true
}

variable "alert_level_default" {
  type    = string
  default = "general_medium"
}

variable "monitor_data" {
  type = object({
    alert = object({
      topic_map = map(object({
        topic_arn = string
      }))
    })
  })
}

variable "name_append" {
  type        = string
  default     = "failed"
  description = "Set null to not append a name"
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
