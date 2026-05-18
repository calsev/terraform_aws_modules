variable "iam_data" {
  type = object({
    iam_instance_profile_arn_ecs        = string
    iam_policy_arn_batch_submit_job     = string
    iam_policy_arn_ec2_associate_eip    = string
    iam_policy_arn_ec2_modify_attribute = string
    iam_policy_arn_ecr_get_token        = string
    iam_policy_arn_ecs_exec_ssm         = string
    iam_policy_arn_ecs_start_task       = string
    iam_policy_arn_ecs_task_execution   = string
    iam_policy_arn_lambda_vpc           = string
    iam_role_arn_backup_create          = string
    iam_role_arn_batch_service          = string
    iam_role_arn_batch_spot_fleet       = string
    iam_role_arn_ecs_task_execution     = string
    iam_role_arn_rds_monitor            = string
    key_pair_map = map(object({
      key_pair_name = string
    }))
  })
}

variable "monitor_data" {
  type = object({
    alert = object({
      topic_map = map(object({
        policy_map = map(object({
          iam_policy_arn = string
        }))
        topic_arn = string
      }))
    })
    ecs_ssm_param_map = object({
      cpu = object({
        policy_map = map(object({
          iam_policy_arn = string
        }))
        name_effective = string
      })
      gpu = object({
        policy_map = map(object({
          iam_policy_arn = string
        }))
        name_effective = string
      })
    })
  })
}

variable "nat_map" {
  type = map(object({
    image_id                    = optional(string)
    instance_storage_gib        = optional(number)
    instance_type               = optional(string)
    k_az                        = string
    k_az_full                   = string
    key_name                    = optional(string)
    k_seg                       = string
    k_vpc                       = string
    tags                        = map(string)
    vpc_security_group_key_list = optional(list(string))
    vpc_segment_key             = optional(string)
  }))
}

variable "nat_image_id_default" {
  type    = string
  default = null
}

variable "nat_instance_storage_gib_default" {
  type    = number
  default = 16
}

variable "nat_instance_type_default" {
  type    = string
  default = "t4g.nano"
}

variable "nat_key_name_default" {
  type        = string
  default     = null
  description = "If provided, also add ssh rule to vpc_security_group_key_list"
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    config_name                    = string
    env                            = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}

variable "vpc_data_map" {
  type = map(object({
    name_simple           = string
    security_group_id_map = map(string)
    segment_map = map(object({
      route_public  = bool
      subnet_id_map = map(string)
      subnet_map = map(object({
        availability_zone_name = string
      }))
    }))
    vpc_assign_ipv6_cidr = bool
    vpc_cidr_block       = string
    vpc_id               = string
    vpc_ipv6_cidr_block  = string
  }))
}

variable "vpc_security_group_key_list_default" {
  type = list(string)
  default = [
    "internal_all_in",
    "world_all_out",
    "world_icmp_in",
  ]
}

variable "vpc_segment_key_default" {
  type    = string
  default = "public"
}
