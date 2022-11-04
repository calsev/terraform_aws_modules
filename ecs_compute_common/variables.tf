variable "compute_environment" {
  type = object({
    image_id                 = string
    instance_allocation_type = string
    instance_storage_gib     = number
    instance_type            = string
    key_name                 = string
    user_data_commands       = list(string)
  })
}

variable "iam_instance_profile_arn_for_ecs" {
  type = string
}

variable "name" {
  type = string
}

variable "security_group_id_list" {
  type = list(string)
}

variable "set_ecs_cluster_in_user_data" {
  type = bool
}

variable "ssm_param_name_cw_config" {
  type = string
}

variable "std_map" {
  type = object({
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
