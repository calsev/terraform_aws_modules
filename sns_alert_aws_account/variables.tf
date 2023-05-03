variable "alert_level_list" {
  type    = list(string)
  default = ["general_high", "general_low", "general_medium"]
}

variable "email_list" {
  type = list(string)
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    iam_partition                  = string
    aws_account_id                 = string
    aws_region_name                = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
