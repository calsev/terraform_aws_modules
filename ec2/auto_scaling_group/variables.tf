variable "group_map" {
  type = map(object({
    auto_scaling_iam_role_arn_service_linked = optional(string)
    auto_scaling_num_instances_max           = optional(number)
    auto_scaling_num_instances_min           = optional(number)
    auto_scaling_protect_from_scale_in       = optional(bool)
    launch_template_id                       = optional(string)
    name_include_app_fields                  = optional(bool)
    name_infix                               = optional(bool)
    placement_group_id                       = optional(string)
    vpc_az_key_list                          = optional(list(string))
    vpc_key                                  = optional(string)
    vpc_security_group_key_list              = optional(list(string))
    vpc_segment_key                          = optional(string)
  }))
}

variable "group_auto_scaling_iam_role_arn_service_linked_default" {
  type    = string
  default = null
}

variable "group_auto_scaling_num_instances_max_default" {
  type    = number
  default = 1
}

variable "group_auto_scaling_num_instances_min_default" {
  type    = number
  default = 0
}

variable "group_auto_scaling_protect_from_scale_in_default" {
  type    = bool
  default = false
}

variable "group_launch_template_id_default" {
  type    = string
  default = null
}

variable "group_name_include_app_fields_default" {
  type        = bool
  default     = false
  description = "If true, the Terraform project context will be included in the name"
}

variable "group_name_infix_default" {
  type    = bool
  default = true
}

variable "group_placement_group_id_default" {
  type    = string
  default = null
}

variable "std_map" {
  type = object({
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "vpc_az_key_list_default" {
  type    = list(string)
  default = ["a", "b"]
}

variable "vpc_data_map" {
  type = map(object({
    security_group_id_map = map(string)
    segment_map = map(object({
      route_public  = bool
      subnet_id_map = map(string)
    }))
    vpc_id = string
  }))
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "vpc_security_group_key_list_default" {
  type    = list(string)
  default = ["world_all_out"]
}

variable "vpc_segment_key_default" {
  type    = string
  default = "internal"
}
