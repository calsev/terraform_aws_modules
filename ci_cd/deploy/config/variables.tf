variable "deployment_map" {
  type = map(object({
    compute_platform                    = optional(string)
    host_healthy_metric                 = optional(string)
    host_healthy_min_value              = optional(string)
    name_append                         = optional(string)
    name_include_app_fields             = optional(bool)
    name_infix                          = optional(bool)
    name_prefix                         = optional(string)
    name_prepend                        = optional(string)
    name_suffix                         = optional(string)
    traffic_routing_interval_minutes    = optional(string)
    traffic_routing_interval_percentage = optional(string)
    traffic_routing_type                = optional(string)
  }))
}

variable "deployment_compute_platform_default" {
  type    = string
  default = "ECS"
  validation {
    condition     = contains(["ECS", "Lambda", "Server"], var.deployment_compute_platform_default)
    error_message = "Invalid compute platform"
  }
}

variable "deployment_host_healthy_metric_default" {
  type        = string
  default     = "FLEET_PERCENT"
  description = "Ignored except for platforms other than Server"
  validation {
    condition     = contains(["FLEET_PERCENT", "HOST_COUNT"], var.deployment_host_healthy_metric_default)
    error_message = "Invalid host metric type"
  }
}

variable "deployment_host_healthy_min_value_default" {
  type        = number
  default     = 100
  description = "Either a fleet percentage or host count. Ignored except for platforms other than Server."
}

variable "deployment_traffic_routing_interval_minutes_default" {
  type        = string
  default     = null
  description = "Ignored for AllAtOnce type"
}

variable "deployment_traffic_routing_interval_percentage_default" {
  type        = string
  default     = null
  description = "Ignored for AllAtOnce type"
}

variable "deployment_traffic_routing_type_default" {
  type    = string
  default = "AllAtOnce"
  validation {
    condition     = contains(["AllAtOnce", "TimeBasedCanary", "TimeBasedLinear"], var.deployment_traffic_routing_type_default)
    error_message = "Invalid traffic routing type"
  }
}

variable "name_append_default" {
  type        = string
  default     = ""
  description = "Appended after key"
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = true
  description = "If true, standard project context will be prefixed to the name. Ignored if not name_infix."
}

variable "name_infix_default" {
  type        = bool
  default     = true
  description = "If true, standard project prefix and resource suffix will be added to the name"
}

variable "name_prefix_default" {
  type        = string
  default     = ""
  description = "Prepended before context prefix"
}

variable "name_prepend_default" {
  type        = string
  default     = ""
  description = "Prepended before key"
}

# tflint-ignore: terraform_unused_declarations
variable "name_regex_allow_list" {
  type        = list(string)
  default     = []
  description = "By default, all punctuation is replaced by -"
}

variable "name_suffix_default" {
  type        = string
  default     = ""
  description = "Appended after context suffix"
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
