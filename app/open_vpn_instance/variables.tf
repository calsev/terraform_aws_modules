variable "instance_map" {
  type = map(object({
    auto_scaling_num_instances_min     = optional(number)
    auto_scaling_protect_from_scale_in = optional(bool)
    instance_type                      = optional(string)
    key_name                           = optional(string)
    name_include_app_fields            = optional(bool)
    name_infix                         = optional(bool)
  }))
}

variable "instance_auto_scaling_num_instances_min_default" {
  type    = number
  default = 0
}

variable "instance_auto_scaling_protect_from_scale_in_default" {
  type    = bool
  default = false
}

variable "instance_key_name_default" {
  type    = string
  default = null
}

variable "instance_name_include_app_fields_default" {
  type        = bool
  default     = false
  description = "If true, the Terraform project context will be included in the name"
}

variable "instance_name_infix_default" {
  type    = bool
  default = true
}

variable "image_search_ecs_gpu_tag_name" {
  type = object({
    false = optional(object({
      false = map(string)
      true  = map(string)
    }))
    true = optional(object({
      false = map(string)
      true  = map(string)
    }))
  })
  default = {
    false = {
      false = {
        open_vpn = "OpenVPN Access Server Community Image"
      }
      true = {
        open_vpn = "OpenVPN Access Server Community Image"
      }
    }
  }
  description = "A mapping (is for ECS) -> (is for GPU) -> tag -> prefix for name"
}

variable "image_search_tag_owner" {
  type = map(string)
  default = {
    open_vpn = "444663524611"
  }
  description = "A mapping of tag to owner"
}

variable "instance_type_default" {
  type    = string
  default = "t3a.micro"
}

variable "monitor_data" {
  type = object({
    ecs_ssm_param_map = object({
      cpu = object({
        name_effective = string
      })
      gpu = object({
        name_effective = string
      })
    })
  })
}

variable "std_map" {
  type = object({
    config_name          = string
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
    vpc_assign_ipv6_cidr = bool
    vpc_id               = string
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
    "world_http_in",
    "world_open_vpn_in",
    "world_ssh_in",
  ]
}

variable "vpc_segment_key_default" {
  type    = string
  default = "public"
}
