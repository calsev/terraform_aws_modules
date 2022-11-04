variable "api_map" {
  type = map(object({
    api_id         = string
    deployment_id  = string
    domain_name_id = optional(string) # If set, a mapping will be created
    integration_map = map(object({
      route_map = map(object({ # All routes are reproduced for each stage
      }))
    }))
    log_group_arn = string
    stage_map = map(object({ # Settings are applied uniformly to all routes for a stage
      detailed_metrics_enabled = optional(bool)
      enable_default_route     = optional(bool)
      throttling_burst_limit   = optional(number)
      throttling_rate_limit    = optional(number)
    }))
  }))
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

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    iam_partition                  = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
