variable "alarm_metric_name_list_default" {
  type    = list(string)
  default = []
}

variable "alarm_monitoring_enabled_default" {
  type        = bool
  default     = true
  description = "Ignored unless at least one alarm is specified"
}

variable "alarm_rollback_enabled_default" {
  type        = bool
  default     = true
  description = "Ignored unless at least one alarm is specified"
}

variable "dns_data" {
  type = object({
    domain_to_sd_zone_map = map(object({
      id = string
    }))
  })
  default     = null
  description = "Must be provided is service discovery is enabled for any service"
}

variable "ecs_cluster_data" {
  type = map(object({
    capability_type        = string
    capacity_provider_name = string
    ecs_cluster_id         = string
  }))
  description = "Instance values must be provided for EC2 capacity type"
}

variable "ecs_task_definition_data_map" {
  type = map(object({
    network_mode                   = string
    task_definition_arn_latest_rev = string # Latest causes a dirty plan
  }))
}

variable "elb_target_data_map" {
  type = map(object({
    target_group_arn = string
  }))
  default     = null
  description = "Must be provided if any ASG has an attached ELB"
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = true
  description = "If true, the Terraform project context will be included in the name"
}

variable "name_infix_default" {
  type    = bool
  default = true
}

variable "service_map" {
  type = map(object({
    alarm_metric_name_list                         = optional(list(string))
    alarm_monitoring_enabled                       = optional(bool)
    alarm_rollback_enabled                         = optional(bool)
    assign_public_ip                               = optional(bool)
    container_definition_map                       = optional(map(object({})), {})
    deployment_controller_circuit_breaker_enabled  = optional(bool)
    deployment_controller_circuit_breaker_rollback = optional(bool)
    deployment_controller_type                     = optional(string)
    deployment_maximum_percent                     = optional(string)
    deployment_minimum_healthy_percent             = optional(string)
    desired_count                                  = optional(number)
    ecs_cluster_key                                = optional(string)
    ecs_task_definition_key                        = optional(string)
    elb_container_name                             = optional(string)
    elb_container_port                             = optional(number)
    elb_health_check_grace_period_seconds          = optional(number)
    elb_target_group_key_list                      = optional(list(string))
    execute_command_enabled                        = optional(bool)
    force_new_deployment                           = optional(bool)
    iam_role_arn_elb_calls                         = optional(string)
    managed_tags_enabled                           = optional(bool)
    propagate_tag_source                           = optional(string)
    scheduling_strategy                            = optional(string)
    sd_container_name                              = optional(string)
    sd_container_port                              = optional(number)
    sd_hostname                                    = optional(string)
    sd_namespace_key                               = optional(string)
    sd_port                                        = optional(number)
    vpc_az_key_list                                = optional(list(string))
    vpc_key                                        = optional(string)
    vpc_security_group_key_list                    = optional(list(string))
    vpc_segment_key                                = optional(string)
  }))
}

variable "service_assign_public_ip_default" {
  type        = bool
  default     = null
  description = "Ignored for EC2 launch type. Defaults to the subnet default for Fargate."
}

variable "service_deployment_controller_circuit_breaker_enabled_default" {
  type        = bool
  default     = true
  description = "Ignored unless deployment controller type is ECS"
}

variable "service_deployment_controller_circuit_breaker_rollback_default" {
  type        = bool
  default     = true
  description = "Ignored unless deployment controller type is ECS"
}

variable "service_deployment_controller_type_default" {
  type    = string
  default = "ECS"
  validation {
    condition     = contains(["CODE_DEPLOY", "ECS", "EXTERNAL"], var.service_deployment_controller_type_default)
    error_message = "Invalid deployment controller type"
  }
}

variable "service_deployment_maximum_percent_default" {
  type        = number
  default     = 200
  description = "Ignored for DAEMON scheduling strategy"
}

variable "service_deployment_minimum_healthy_percent_default" {
  type        = number
  default     = 100
  description = "Ignored for DAEMON scheduling strategy"
}

variable "service_desired_count_default" {
  type        = number
  default     = 1
  description = "Ignored for DAEMON scheduling strategy"
}

variable "service_ecs_cluster_key_default" {
  type        = string
  default     = null
  description = "Defaults to service key"
}

variable "service_ecs_task_definition_key_default" {
  type        = string
  default     = null
  description = "Defaults to service key"
}

variable "service_elb_container_name_default" {
  type        = string
  default     = null
  description = "Every service attached to an ELB must provide an ELB container name or a container map with a single container"
}

variable "service_elb_container_port_default" {
  type    = number
  default = 80
}

variable "service_elb_health_check_grace_period_seconds_default" {
  type        = number
  default     = 300
  description = "Ignored unless attached to at least one target group"
}

variable "service_elb_target_group_key_list_default" {
  type    = list(string)
  default = []
}

variable "service_execute_command_enabled_default" {
  type    = bool
  default = true
}

variable "service_force_new_deployment_default" {
  type        = bool
  default     = true
  description = "Avoids several configuration headaches. Ignored for CODE_DEPLOY controller."
}

variable "service_iam_role_arn_elb_calls_default" {
  type        = string
  default     = null
  description = "Ignored if networking mode is awvpc"
}

variable "service_managed_tags_enabled_default" {
  type    = bool
  default = true
}

variable "service_propagate_tag_source_default" {
  type    = string
  default = "SERVICE"
  validation {
    condition     = contains(["SERVICE", "TASK_DEFINITION"], var.service_propagate_tag_source_default)
    error_message = "Invalid scheduling strategy"
  }
}

variable "service_scheduling_strategy_default" {
  type        = string
  default     = "REPLICA"
  description = "DAEMON is compatible with only ECS deployment controller and conflicts with desired count."
  validation {
    condition     = contains(["DAEMON", "REPLICA"], var.service_scheduling_strategy_default)
    error_message = "Invalid scheduling strategy"
  }
}

variable "service_sd_namespace_key_default" {
  type    = string
  default = null
}

variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "vpc_az_key_list_default" {
  type    = list(string)
  default = ["a", "b"]
}

variable "vpc_data_map" {
  type = map(object({
    security_group_id_map = map(string)
    segment_map = map(object({
      route_public  = bool
      subnet_id_map = map(string)
    }))
    vpc_id = string
  }))
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "vpc_security_group_key_list_default" {
  type = list(string)
  default = [
    "internal_http_in",
    "world_all_out",
  ]
}

variable "vpc_segment_key_default" {
  type    = string
  default = "internal"
}
