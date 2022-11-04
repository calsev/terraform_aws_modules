variable "create_policy" {
  type    = bool
  default = true
}

variable "log_retention_days" {
  type    = number
  default = 14
  validation {
    condition     = contains([0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.log_retention_days)
    error_message = "Log retention must be one of a set of allowed values"
  }
}

variable "name" {
  type = string
}

variable "policy_name" {
  type        = string
  default     = null
  description = "Defaults to name-log"
}

variable "policy_name_infix" {
  type    = bool
  default = true
}

variable "policy_name_prefix" {
  type    = string
  default = ""
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    iam_partition                  = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}
