variable "s3_data_map" {
  type = map(object({
    policy = object({
      iam_policy_arn_map = map(string)
    })
  }))
}

variable "log_bucket_key" {
  type = string
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
