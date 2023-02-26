variable "name_prefix" {
  type    = string
  default = ""
}

variable "std_map" {
  type = object({
    aws_account_id  = string
    aws_region_name = string
    assume_role_json = object({
      ec2          = string
      task_starter = string
    })
    iam_partition        = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
