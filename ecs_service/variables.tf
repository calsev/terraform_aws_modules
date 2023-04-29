variable "dns_data" {
  type = object({
    domain_to_sd_zone_map = map(object({
      id = string
    }))
    ttl_map = object({
      alias = number
    })
  })
}

variable "ecs_cluster_data" {
  type = map(object({
    capability_type        = string
    capacity_provider_name = string
    ecs_cluster_id         = string
  }))
  description = "Instance values must be provided for EC2 capacity type"
}

variable "service_map" {
  type = map(object({
    assign_public_ip            = optional(bool)
    desired_count               = optional(number)
    ecs_cluster_key             = optional(string)
    ecs_task_definition_arn     = optional(string)
    sd_container_name           = optional(string)
    sd_container_port           = optional(number)
    sd_hostname                 = optional(string)
    sd_namespace_key            = optional(string)
    sd_port                     = optional(number)
    vpc_az_key_list             = optional(list(string))
    vpc_key                     = optional(string)
    vpc_security_group_key_list = optional(list(string))
    vpc_segment_key             = optional(string)
  }))
}

variable "service_assign_public_ip_default" {
  type        = bool
  default     = null
  description = "Ignored for EC2 launch type. Defaults to the subnet default for Fargate."
}

variable "service_desired_count_default" {
  type    = number
  default = 1
}

variable "service_ecs_cluster_key_default" {
  type    = string
  default = null
}

variable "service_ecs_task_definition_arn_default" {
  type    = string
  default = null
}

variable "service_sd_namespace_key_default" {
  type    = string
  default = null
}

variable "std_map" {
  type = object({
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
  }))
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "vpc_security_group_key_list_default" {
  type = list(string)
  default = [
    "world_all_out",
  ]
}

variable "vpc_segment_key_default" {
  type    = string
  default = "internal"
}
