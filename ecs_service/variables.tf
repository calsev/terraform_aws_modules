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

variable "security_group_id_list" {
  type = list(string)
}

variable "std_map" {
  type = object({
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "subnet_id_list" {
  type = list(string)
}

variable "ttl_dns_a" {
  type    = number
  default = null
}
