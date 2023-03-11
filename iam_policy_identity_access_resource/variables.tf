variable "access_list" {
  type = list(string)
}

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
  description = "If provided, will be put in front of the standard prefix for the policy"
}

variable "resource_map" {
  type        = map(list(string))
  description = "A map of resource type to resource names"
}

variable "service_name" {
  type = string
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}

variable "tag" {
  type    = bool
  default = true
}
