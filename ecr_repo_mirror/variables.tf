variable "ecr_repo_name" {
  type    = string
  default = "ecr_repo_mirror"
}

variable "iam_data" {
  type = object({
    iam_instance_profile_arn_ecs    = string
    iam_policy_arn_batch_submit_job = string
    iam_policy_arn_ecr_get_token    = string
    iam_policy_arn_ecs_start_task   = string
    iam_role_arn_ecs_task_execution = string
  })
}

variable "instance_type" {
  type    = string
  default = "t4g.micro"
}

variable "min_instances" {
  type    = number
  default = 0
}

variable "monitor_data" {
  type = object({
    alert = object({
      topic_map = map(object({
        topic_arn = string
      }))
    })
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

variable "schedule_expression" {
  type    = string
  default = "cron(0 7 ? * SAT *)" # every Saturday at 7am UTC
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

variable "task_name" {
  type    = string
  default = "ecr_mirror"
}

variable "vpc_az_key_list" {
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

variable "vpc_key" {
  type    = string
  default = null
}

variable "vpc_security_group_key_list" {
  type    = list(string)
  default = ["world_all_out"]
}

variable "vpc_segment_key" {
  type    = string
  default = "internal"
}
