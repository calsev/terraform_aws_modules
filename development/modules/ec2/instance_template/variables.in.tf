variable "compute_map" {
  type = map(object({
    api_stop_disabled               = optional(bool)
    auto_recovery_enabled           = optional(bool)
    cpu_option_amd_sev_snp_enabled  = optional(bool)
    cpu_option_core_count           = optional(number)
    cpu_option_threads_per_core     = optional(number)
    dns_private_aaaa_record_enabled = optional(bool)
    dns_private_a_record_enabled    = optional(bool)
    dns_private_hostname_type       = optional(string)
    ebs_optimized                   = optional(bool)
    hibernation_enabled             = optional(bool)
    iam_instance_profile_arn        = optional(string)
    image_id                        = optional(string)
    image_search_for_ecs            = optional(bool)
    image_search_tag                = optional(string)
    instance_allocation_type        = optional(string)
    instance_storage_gib            = optional(number)
    instance_type                   = optional(string)
    key_pair_key                    = optional(string)
    metadata_endpoint_enabled       = optional(bool)
    metadata_version_2_required     = optional(bool)
    metadata_ipv6_enabled           = optional(bool)
    metadata_response_hop_limit     = optional(number)
    metadata_tags_enabled           = optional(bool)
    monitoring_advanced_enabled     = optional(bool)
    {{ name.var_item() }}
    nitro_enclaves_enabled          = optional(bool)
    placement_partition_count       = optional(number)
    placement_spread_level          = optional(string)
    placement_strategy              = optional(string)
    storage_volume_encrypted        = optional(bool)
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

variable "compute_api_stop_disabled_default" {
  type    = bool
  default = false
}

variable "compute_auto_recovery_enabled_default" {
  type    = bool
  default = true
}

variable "compute_cpu_option_amd_sev_snp_enabled_default" {
  type    = bool
  default = null
}

variable "compute_cpu_option_core_count_default" {
  type    = number
  default = null
}

variable "compute_cpu_option_threads_per_core_default" {
  type    = number
  default = null
}

variable "compute_dns_private_aaaa_record_enabled_default" {
  type    = bool
  default = true
}

variable "compute_dns_private_a_record_enabled_default" {
  type    = bool
  default = true
}

variable "compute_dns_private_hostname_type_default" {
  type        = string
  default     = "ip-name"
  description = "For IPv4 networks, ip-name is required. For IPv6 resource-name. For duplex either is allowed."
  validation {
    condition     = contains(["ip-name", "resource-name"], var.compute_dns_private_hostname_type_default)
    error_message = "Invalid hostname type"
  }
}

variable "compute_ebs_optimized_default" {
  type    = bool
  default = false
}

variable "compute_hibernation_enabled_default" {
  type    = bool
  default = false
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

variable "compute_key_pair_key_default" {
  type    = string
  default = null
}

variable "compute_metadata_endpoint_enabled_default" {
  type    = bool
  default = true
}

variable "compute_metadata_version_2_required_default" {
  type        = bool
  default     = true
  description = "A high severity finding if disabled"
}

variable "compute_metadata_ipv6_enabled_default" {
  type    = bool
  default = true
}

variable "compute_metadata_response_hop_limit_default" {
  type    = number
  default = 1
}

variable "compute_metadata_tags_enabled_default" {
  type    = bool
  default = true
}

variable "compute_monitoring_advanced_enabled_default" {
  type    = bool
  default = true
}

variable "compute_nitro_enclaves_enabled_default" {
  type    = bool
  default = false
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

variable "instance_storage_volume_encrypted_default" {
  type        = bool
  default     = true
  description = "A medium-level security finding if disabled"
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

variable "iam_data" {
  type = object({
    key_pair_map = map(object({
      key_pair_name = string
    }))
  })
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

{{ name.var() }}

variable "set_ecs_cluster_in_user_data" {
  type    = bool
  default = false
}

{{ std.map() }}

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
