variable "name" {
  type        = string
  default     = null
  description = "If provided, a policy will be created"
}

variable "name_infix" {
  type        = bool
  default     = true
  description = "If true, standard resource prefix and suffix will be applied to the policy"
}

variable "name_prefix" {
  type        = string
  default     = ""
  description = "If provided, will be put in front of the standard prefix for the policy name"
}

variable "sid_map" {
  type = map(object({
    access           = string
    bucket_name_list = list(string) # Can be bucket names, bucket ARNs, access point ARNs
    object_key_list  = optional(list(string))
  }))
}

variable "sid_object_key_list_default" {
  type    = list(string)
  default = ["*"]
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
