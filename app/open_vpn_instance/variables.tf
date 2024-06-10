variable "dns_data" {
  type = object({
    domain_to_dns_zone_map = map(object({
      dns_zone_id = string
    }))
  })
}

variable "iam_data" {
  type = object({
    iam_policy_arn_ec2_associate_eip    = string
    iam_policy_arn_ec2_modify_attribute = string
    key_pair_map = map(object({
      key_pair_name = string
    }))
  })
}

variable "instance_map" {
  type = map(object({
    auto_scaling_protect_from_scale_in = optional(bool)
    cert_contact_email                 = optional(string)
    create_instance                    = optional(bool)
    dns_from_fqdn                      = optional(string) # Defaults to vpn.${from_zone_key}
    dns_from_zone_key                  = optional(string)
    instance_type                      = optional(string)
    key_pair_key                       = optional(string)
    name_include_app_fields            = optional(bool)
    name_infix                         = optional(bool)
    secret_is_param                    = optional(bool)
    user_data_suppress_generation      = optional(bool)
  }))
}

variable "instance_auto_scaling_protect_from_scale_in_default" {
  type    = bool
  default = false
}

variable "instance_cert_contact_email_default" {
  type    = string
  default = null
}

variable "instance_create_instance_default" {
  type    = bool
  default = true
}

variable "instance_dns_from_zone_key_default" {
  type    = string
  default = null
}

variable "instance_key_pair_key_default" {
  type    = string
  default = null
}

variable "instance_secret_is_param_default" {
  type    = bool
  default = false
}

variable "instance_user_data_suppress_generation_default" {
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
        iam_policy_arn_map = map(string)
        name_effective     = string
      })
      gpu = object({
        iam_policy_arn_map = map(string)
        name_effective     = string
      })
    })
  })
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = false
  description = "If true, the Terraform project context will be included in the name"
}

variable "name_infix_default" {
  type    = bool
  default = true
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    config_name                    = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
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
    "internal_ssh_in",
    "world_all_out",
    "world_http_in",
    "world_open_vpn_in",
  ]
}

variable "vpc_segment_key_default" {
  type    = string
  default = "public"
}
