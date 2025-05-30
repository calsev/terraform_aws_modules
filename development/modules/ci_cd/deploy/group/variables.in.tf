variable "alarm_ignore_poll_failure_default" {
  type        = bool
  default     = true
  description = "Ignored unless at least one alarm is specified"
}

variable "alarm_metric_name_list_default" {
  type    = list(string)
  default = []
}

variable "alarm_monitoring_enabled_default" {
  type        = bool
  default     = true
  description = "Ignored unless at least one alarm is specified"
}

variable "ci_cd_account_data" {
  type = object({
    role = object({
      deploy = object({
        ecs = object({
          iam_role_arn = string
        })
      })
    })
  })
}

variable "alert_enabled_default" {
  type    = bool
  default = true
}

variable "alert_level_default" {
  type    = string
  default = "general_medium"
}

variable "deployment_app_data_map" {
  type = map(object({
    name_effective = string
  }))
}

variable "deployment_config_data_map" {
  type = map(object({
    name_effective = string
  }))
}

variable "ecs_cluster_data_map" {
  type = map(object({
    auto_scaling_group = optional(object({
      auto_scaling_group_arn = string
    }))
    name_effective = string
  }))
}

variable "ecs_service_data_map" {
  type = map(object({
    name_effective = string
  }))
}

variable "elb_listener_data_map" {
  type = map(object({
    elb_listener_target_arn = string
  }))
  default     = null
  description = "Must be provided if any group uses blue-green deployment"
}

variable "elb_target_data_map" {
  type = map(object({
    target_group_name = string
  }))
}

variable "deployment_map" {
  type = map(object({
    alarm_ignore_poll_failure           = optional(bool)
    alarm_metric_name_list              = optional(list(string))
    alarm_monitoring_enabled            = optional(bool)
    alert_enabled                       = optional(bool)
    alert_level                         = optional(string)
    auto_rollback_enabled               = optional(bool)
    auto_rollback_event_list            = optional(list(string))
    blue_green_terminate_on_success     = optional(bool)
    blue_green_termination_wait_minutes = optional(number)
    blue_green_timeout_action           = optional(string)
    blue_green_timeout_wait_minutes     = optional(number)
    deployment_app_key                  = optional(string)
    deployment_config_key               = optional(string)
    deployment_environment_map = optional(object({
      blue = object({
        elb_listener_key     = optional(string)
        elb_target_group_key = optional(string)
      })
      green = optional(object({ # If this is included, the depoyment will use blue-green
        elb_listener_key     = optional(string)
        elb_target_group_key = optional(string)
      }))
    }))
    deployment_style_use_load_balancer = optional(bool)
    ecs_service_map = map(object({
      cluster_key = optional(string)
    }))
    {{ name.var_item() }}
    trigger_map = optional(map(object({
      event_list    = optional(list(string))
      sns_topic_arn = optional(string)
    })))
    update_new_instances = optional(bool)
  }))
}

variable "deployment_auto_rollback_enabled_default" {
  type    = string
  default = true
}

variable "deployment_auto_rollback_event_list_default" {
  type    = list(string)
  default = ["DEPLOYMENT_FAILURE", "DEPLOYMENT_STOP_ON_ALARM", "DEPLOYMENT_STOP_ON_REQUEST"]
  validation {
    condition     = length(setsubtract(toset(var.deployment_auto_rollback_event_list_default), toset(["DEPLOYMENT_FAILURE", "DEPLOYMENT_STOP_ON_ALARM", "DEPLOYMENT_STOP_ON_REQUEST"]))) == 0
    error_message = "Invalid event list"
  }
}

variable "deployment_blue_green_terminate_on_success_default" {
  type    = bool
  default = true
}

variable "deployment_blue_green_termination_wait_minutes_default" {
  type        = number
  default     = 0
  description = "Ignored unless terminate_on_success is true. No other deployment can commence during this wait."
}

variable "deployment_blue_green_timeout_action_default" {
  type        = string
  default     = "CONTINUE_DEPLOYMENT"
  description = "Set to STOP_DEPLOYMENT if something will `aws deploy continue-deployment` else CONTINUE_DEPLOYMENT"
  validation {
    condition     = contains(["CONTINUE_DEPLOYMENT", "STOP_DEPLOYMENT"], var.deployment_blue_green_timeout_action_default)
    error_message = "Invalid action"
  }
}

variable "deployment_blue_green_timeout_wait_minutes_default" {
  type        = number
  default     = 5
  description = "Ignored unless timeout action is STOP_DEPLOYMENT"
}

variable "deployment_app_key_default" {
  type        = string
  default     = null
  description = "Defaults to group key"
}

variable "deployment_config_key_default" {
  type        = string
  default     = null
  description = "Defaults to group key"
}

variable "deployment_style_use_load_balancer_default" {
  type        = bool
  default     = true
  description = "If true a target group and load balancer must be provided"
}

variable "deployment_environment_map_default" {
  type = object({
    blue = object({
      elb_listener_key     = optional(string) # Defaults to key_blue
      elb_target_group_key = optional(string) # Defaults to key_blue
    })
    green = optional(object({                 # If this is included, the depoyment will use blue-green
      elb_listener_key     = optional(string) # Defaults to key_green
      elb_target_group_key = optional(string) # Defaults to key_green
    }))
  })
  default = {
    blue  = {}
    green = {}
  }
}

variable "deployment_ecs_service_cluster_key_default" {
  type    = string
  default = null
}

variable "deployment_trigger_map_default" {
  type = map(object({
    event_list    = optional(list(string))
    sns_topic_arn = optional(string)
  }))
  default = {}
}

variable "deployment_trigger_event_list_default" {
  type    = list(string)
  default = ["DEPLOYMENT_FAILURE"]
  validation {
    condition     = length(setsubtract(toset(var.deployment_trigger_event_list_default), toset(["DEPLOYMENT_FAILURE", "DEPLOYMENT_STOP_ON_ALARM", "DEPLOYMENT_STOP_ON_REQUEST"]))) == 0
    error_message = "Invalid event list"
  }
}

variable "deployment_trigger_sns_topic_arn_default" {
  type    = string
  default = null
}

variable "deployment_update_new_instances_default" {
  type    = bool
  default = true
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

{{ name.var() }}

{{ std.map() }}
