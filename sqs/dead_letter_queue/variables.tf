variable "name_append" {
  type        = string
  default     = "dead_letter"
  description = "Set null to not append a name"
}

variable "queue_map" {
  type = map(object({
    dead_letter_policy_create = optional(bool)
    dead_letter_queue_enabled = optional(bool)
  }))
}

variable "policy_create_default" {
  type        = bool
  default     = true
  description = "Ignored if queue is not enabled"
}

variable "queue_enabled_default" {
  type    = bool
  default = true
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
