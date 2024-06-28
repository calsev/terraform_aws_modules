variable "record_retention_period_days" {
  type        = number
  default     = 2557
  description = "This should be set to 7 years for legal discovery"
}

variable "s3_bucket_key" {
  type = string
}

variable "s3_data_map" {
  type = map(object({
    name_effective = string
  }))
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
