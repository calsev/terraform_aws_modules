variable "compute_map" {
  type = map(object({
    iam_instance_profile_arn        = optional(string)
    image_id                        = optional(string)
    image_search_for_ecs            = optional(bool)
    image_search_tag                = optional(string)
    instance_allocation_type        = optional(string)
    instance_storage_gib            = optional(number)
    instance_type                   = optional(string)
    key_name                        = optional(string)
    monitoring_advanced_enabled     = optional(bool)
    name_include_app_fields         = optional(bool)
    name_infix                      = optional(bool)
    placement_partition_count       = optional(number)
    placement_spread_level          = optional(string)
    placement_strategy              = optional(string)
    storage_volume_type             = optional(string)
    update_default_template_version = optional(bool)
    user_data_command_list          = optional(list(string))
    user_data_file_map = optional(map(object({
      content     = string
      permissions = string
    })))
    user_data_suppress_generation = optional(bool)
    vpc_az_key_list               = optional(list(string))
    vpc_key                       = optional(string)
    vpc_security_group_key_list   = optional(list(string))
    vpc_segment_key               = optional(string)
  }))
}

variable "compute_iam_instance_profile_arn_default" {
  type    = string
  default = null
}

variable "compute_image_id_default" {
  type        = string
  default     = null
  description = "If provided, this image will be used, otherwise an image search will be performed"
}

variable "compute_image_search_for_ecs_default" {
  type    = bool
  default = false
}

variable "compute_image_search_tag_default" {
  type        = string
  default     = "ubuntu"
  description = "Ignored if the image is for ECS"
}

variable "compute_instance_allocation_type_default" {
  type    = string
  default = "EC2"
}

variable "compute_instance_storage_gib_default" {
  type    = number
  default = 30
}

variable "compute_instance_type_default" {
  type    = string
  default = null
}

variable "compute_key_name_default" {
  type    = string
  default = null
}

variable "compute_monitoring_advanced_enabled_default" {
  type    = bool
  default = true
}

variable "compute_name_include_app_fields_default" {
  type        = bool
  default     = true
  description = "If true, the Terraform project context will be included in the name"
}

variable "compute_name_infix_default" {
  type    = bool
  default = true
}

variable "compute_placement_partition_count_default" {
  type        = number
  default     = 7
  description = "Ignored unless placement strategy is partition."
  validation {
    condition     = 0 < var.compute_placement_partition_count_default && var.compute_placement_partition_count_default < 8
    error_message = "Invalid partition count"
  }
}

variable "compute_placement_spread_level_default" {
  type        = string
  default     = "rack"
  description = "This must be rack in regional data centers and host on outposts. Ignored unless placement strategy is spread."
}

variable "compute_placement_strategy_default" {
  type    = string
  default = "partition"
  validation {
    condition     = contains(["cluster", "partition", "spread"], var.compute_placement_strategy_default)
    error_message = "Invalid placement strategy"
  }
  description = "Spread allows 7 instances per AZ. Partition allows 7 partitions per AZ, with unlimited instances per partition."
}

variable "compute_storage_volume_type_default" {
  type    = string
  default = "gp3"
}

variable "compute_update_default_template_version_default" {
  type    = bool
  default = true
}

variable "compute_user_data_command_list_default" {
  type    = list(string)
  default = null
}

variable "compute_user_data_file_map_default" {
  type = map(object({
    content     = string
    permissions = string
  }))
  default = {}
}

variable "compute_user_data_suppress_generation_default" {
  type    = bool
  default = false
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
        amazon = "al2023-ami-hvm-*"
        ubuntu = "ubuntu/images/hvm-ssd/ubuntu-jammy-*"
      }
      true = {
        amazon = "amzn2-ami-hvm-*"
        ubuntu = "ubuntu/images/hvm-ssd/ubuntu-jammy-*"
      }
    }
    true = {
      false = {
        amazon = "al2023-ami-ecs-hvm-*"
      }
      true = {
        amazon = "amzn2-ami-ecs-gpu-*"
      }
    }
  }
  description = "A mapping (is for ECS) -> (is for GPU) -> tag -> prefix for name"
}

variable "image_search_tag_owner" {
  type = map(string)
  default = {
    amazon = "amazon"
    ubuntu = "099720109477"
  }
  description = "A mapping of tag to owner"
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

variable "set_ecs_cluster_in_user_data" {
  type    = bool
  default = false
}

variable "std_map" {
  type = object({
    aws_region_name      = string
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
    vpc_id = string
  }))
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "vpc_security_group_key_list_default" {
  type    = list(string)
  default = ["world_all_out"]
}

variable "vpc_segment_key_default" {
  type    = string
  default = "internal"
}
