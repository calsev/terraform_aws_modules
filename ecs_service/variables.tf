variable "assign_public_ip" {
  type        = bool
  default     = false
  description = "Not supported for EC2 launch type"
}

variable "capacity_provider_name" {
  type = string
}

variable "desired_count" {
  type = number
}

variable "ecs_cluster_id" {
  type = string
}

variable "ecs_task_definition_arn" {
  type = string
}

variable "name" {
  type = string
}

variable "public_dns_name" {
  type    = string
  default = null
}

variable "sd_namespace_id" {
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

variable "vpc_data" {
  type = object({
    security_group_map = map(object({
      id = string
    }))
    segment_map = map(object({
      subnet_map = map(object({
        subnet_id = string
      }))
    }))
  })
}

variable "vpc_security_group_key_list" {
  type = list(string)
}

variable "vpc_segment_key" {
  type    = string
  default = "internal"
}

variable "vpc_subnet_key_list" {
  type    = list(string)
  default = ["a", "b"]
}
