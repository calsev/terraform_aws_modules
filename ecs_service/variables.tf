variable "service_map" {
  type = map(object({
    assign_public_ip            = optional(bool)
    capacity_provider_name      = optional(string)
    desired_count               = optional(number)
    ecs_cluster_id              = optional(string)
    ecs_task_definition_arn     = optional(string)
    public_dns_name             = optional(string)
    sd_namespace_id             = optional(string)
    vpc_az_key_list             = optional(list(string))
    vpc_key                     = optional(string)
    vpc_security_group_key_list = optional(list(string))
    vpc_segment_key             = optional(string)
  }))
}

variable "service_assign_public_ip_default" {
  type        = bool
  default     = false
  description = "Not supported for EC2 launch type"
}

variable "service_capacity_provider_name_default" {
  type    = string
  default = null
}

variable "service_desired_count_default" {
  type    = number
  default = 1
}

variable "service_ecs_cluster_id_default" {
  type    = string
  default = null
}

variable "service_ecs_task_definition_arn_default" {
  type    = string
  default = null
}

variable "service_public_dns_name_default" {
  type    = string
  default = null
}

variable "service_sd_namespace_id_default" {
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

variable "ttl_dns_a" {
  type    = number
  default = null
}

variable "vpc_az_key_list_default" {
  type    = list(string)
  default = ["a", "b"]
}

variable "vpc_data_map" {
  type = map(object({
    security_group_id_map = map(string)
    segment_map = map(object({
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
