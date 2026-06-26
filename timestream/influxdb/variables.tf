variable "db_map" {
  type = map(object({
    bucket_name                 = optional(string)
    cluster_failover_mode       = optional(string)
    deployment_type             = optional(string)
    instance_type               = optional(string)
    is_cluster                  = optional(bool)
    log_s3_bucket_name          = optional(string)
    maintenance_timezone        = optional(string)
    maintenance_window          = optional(string)
    name_append                 = optional(string)
    name_include_app_fields     = optional(bool)
    name_infix                  = optional(bool)
    name_prefix                 = optional(string)
    name_prepend                = optional(string)
    name_suffix                 = optional(string)
    network_type                = optional(string)
    organization                = optional(string)
    parameter_group_name        = optional(string)
    port                        = optional(number)
    publicly_access_enabled     = optional(bool)
    storage_gib                 = optional(number)
    storage_type                = optional(string)
    username                    = optional(string)
    vpc_az_key_list             = optional(list(string))
    vpc_key                     = optional(string)
    vpc_security_group_key_list = optional(list(string))
    vpc_segment_key             = optional(string)
  }))
}

variable "db_bucket_name_default" {
  type        = string
  default     = null
  description = "Initial DB bucket to be created. Ignored for clusters with parameter group"
}

variable "db_cluster_failover_mode_default" {
  type        = string
  default     = null
  description = "Not supported for V3 clusters"
  validation {
    condition     = var.db_cluster_failover_mode_default == null ? true : contains(["AUTOMATIC", "NO_FAILOVER"], var.db_cluster_failover_mode_default)
    error_message = "Invalid failover mode"
  }
}

variable "db_deployment_type_default" {
  type        = string
  default     = "SINGLE_AZ"
  description = "Ignored for clusters with parameter group"
  validation {
    condition     = contains(["WITH_MULTIAZ_STANDBY", "SINGLE_AZ"], var.db_deployment_type_default)
    error_message = "Invalid deployment type"
  }
}

variable "db_instance_type_default" {
  type    = string
  default = "db.influx.medium"
}

variable "db_is_cluster_default" {
  type    = bool
  default = true
}

variable "db_log_s3_bucket_name_default" {
  type    = string
  default = null
}

variable "db_maintenance_timezone_default" {
  type    = string
  default = "UTC"
}

variable "db_maintenance_window_default" {
  type        = string
  default     = "Sun:05:00-Sun:07:00"
  description = "Must be at least 2 hours"
}

variable "db_network_type_default" {
  type    = string
  default = "DUAL"
  validation {
    condition     = contains(["DUAL", "IPV4"], var.db_network_type_default)
    error_message = "Invalid network type"
  }
}

variable "db_organization_default" {
  type        = string
  default     = null
  description = "Ignored for clusters with parameter group"
}

variable "db_parameter_group_name_production_default" {
  type        = string
  default     = "InfluxDBV3Enterprise1Node"
  description = "Will be used for any env starting with 'pr'."
}

variable "db_parameter_group_name_test_default" {
  type        = string
  default     = "InfluxDBV3Core"
  description = "Will be used for any env not starting with 'pr'."
}

variable "db_port_default" {
  type    = number
  default = 8086
}

variable "db_publicly_access_enabled_default" {
  type    = bool
  default = false
}

variable "db_storage_gib_default" {
  type        = number
  default     = 20
  description = "Ignored for clusters with parameter group"
  validation {
    condition     = var.db_storage_gib_default >= 20
    error_message = "Minimum storage is 20 GiB"
  }
}

variable "db_storage_type_default" {
  type    = string
  default = "InfluxIOIncludedT1"
  validation {
    condition     = contains(["InfluxIOIncludedT1", "InfluxIOIncludedT2", "InfluxIOIncludedT3"], var.db_storage_type_default)
    error_message = "Invalid storage type"
  }
}

variable "db_username_default" {
  type        = string
  default     = null
  description = "Ignored for clusters with parameter group"
}

variable "name_append_default" {
  type        = string
  default     = ""
  description = "Appended after key"
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = true
  description = "If true, standard project context will be prefixed to the name. Ignored if not name_infix."
}

variable "name_infix_default" {
  type        = bool
  default     = true
  description = "If true, standard project prefix and resource suffix will be added to the name"
}

variable "name_prefix_default" {
  type        = string
  default     = ""
  description = "Prepended before context prefix"
}

variable "name_prepend_default" {
  type        = string
  default     = ""
  description = "Prepended before key"
}

# tflint-ignore: terraform_unused_declarations
variable "name_regex_allow_list" {
  type        = list(string)
  default     = []
  description = "By default, all punctuation is replaced by -"
}

variable "name_suffix_default" {
  type        = string
  default     = ""
  description = "Appended after context suffix"
}

variable "std_map" {
  type = object({
    access_title_map               = map(string)
    aws_account_id                 = string
    aws_region_name                = string
    config_name                    = string
    env                            = string
    iam_partition                  = string
    name_replace_regex             = string
    resource_name_prefix           = string
    resource_name_suffix           = string
    service_resource_access_action = map(map(map(list(string))))
    tags                           = map(string)
  })
}

variable "vpc_az_key_list_default" {
  type = list(string)
  default = [
    "a",
    "b",
  ]
}

variable "vpc_data_map" {
  type = map(object({
    name_simple           = string
    security_group_id_map = map(string)
    segment_map = map(object({
      route_public  = bool
      subnet_id_map = map(string)
      subnet_map = map(object({
        availability_zone_name = string
      }))
    }))
    vpc_assign_ipv6_cidr = bool
    vpc_cidr_block       = string
    vpc_id               = string
    vpc_ipv6_cidr_block  = string
  }))
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "vpc_security_group_key_list_default" {
  type = list(string)
  default = [
    "internal_influx_in",
    "world_all_out",
  ]
}

variable "vpc_segment_key_default" {
  type    = string
  default = "internal"
}
