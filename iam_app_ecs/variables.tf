variable "monitor_data" {
  type = object({
    ecs_ssm_param_map = object({
      cpu = object({
        iam_policy_arn_map = map(string)
      })
      gpu = object({
        iam_policy_arn_map = map(string)
      })
    })
  })
}

variable "name_prefix" {
  type    = string
  default = ""
}

variable "std_map" {
  type = object({
    aws_account_id       = string
    aws_region_name      = string
    iam_partition        = string
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
