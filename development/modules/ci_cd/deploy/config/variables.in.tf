variable "deployment_map" {
  type = map(object({
    compute_platform                    = optional(string)
    host_healthy_metric                 = optional(string)
    host_healthy_min_value              = optional(string)
    {{ name.var_item() }}
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

{{ name.var() }}

{{ std.map() }}
