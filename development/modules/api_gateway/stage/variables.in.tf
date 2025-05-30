variable "api_map" {
  type = map(object({
    api_id             = string
    deployment_id      = string
    enable_dns_mapping = bool # If true, a mapping will be created
    integration_map = map(object({
      route_map = map(object({ # All routes are reproduced for each stage
      }))
    }))
    stage_map = map(object({ # Settings are applied uniformly to all routes for a stage
      detailed_metrics_enabled = optional(bool)
      domain_key               = optional(string)
      enable_default_route     = optional(bool)
      stage_path               = optional(string) # Defaults to "" if stage is $default, k_stage otherwise
      throttling_burst_limit   = optional(number)
      throttling_rate_limit    = optional(number)
    }))
  }))
}

variable "domain_data_map" {
  type = map(object({
    domain_id = string
  }))
  default     = null
  description = "Must be provided if any stage has domain key defined"
}

variable "stage_domain_key_default" {
  type        = string
  default     = null
  description = "Defaults to api key"
}

variable "stage_detailed_metrics_enabled_default" {
  type    = bool
  default = true
}

variable "stage_enable_default_route_default" {
  type    = bool
  default = false
}

variable "stage_throttling_burst_limit_default" {
  type    = number
  default = 100
}

variable "stage_throttling_rate_limit_default" {
  type    = number
  default = 200
}

{{ std.map() }}
