variable "create_policies" {
  type        = bool
  default     = true
  description = "If created, these policies can be attached to roles. Otherwise policy documents can be used."
}

variable "encrypt_file_system" {
  type    = bool
  default = false
}

variable "iam_role_id_efs_read_list" {
  type        = list(string)
  default     = []
  description = "Add the read inline policy to these roles."
}

variable "iam_role_id_efs_write_list" {
  type        = list(string)
  default     = []
  description = "Add the write inline policy to these roles."
}

variable "name" {
  type = string
}

variable "security_group_id_egress" {
  type = string
}

variable "std_map" {
  type = object({
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}

variable "subnet_filter_tag" {
  type    = string
  default = "private"
}

variable "vpc_id" {
  type = string
}
