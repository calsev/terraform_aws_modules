variable "compute_map" {
  type = map(object({
    capacity_type      = optional(string)
    log_retention_days = optional(number)
  }))
}

variable "compute_capacity_type_default" {
  type    = string
  default = "FARGATE"
  validation {
    condition     = contains(["FARGATE", "FARGATE_SPOT"], var.compute_capacity_type_default)
    error_message = "Invalid capacity type"
  }
}

variable "compute_log_retention_days_default" {
  type    = number
  default = 7
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
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
