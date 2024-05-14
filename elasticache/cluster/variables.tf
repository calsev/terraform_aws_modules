variable "cluster_map" {
  type = map(object({
    apply_change_immediately           = optional(bool)
    auto_minor_version_upgrade_enabled = optional(bool)
    availability_zone_key              = optional(string)
    az_mode                            = optional(string)
    engine                             = optional(string)
    engine_version                     = optional(string)
    final_snapshot_enabled             = optional(bool)
    ip_discovery_v6                    = optional(bool)
    log_map = optional(map(object({
      log_destination_name = optional(string)
      log_destination_type = optional(string)
      log_format           = optional(string)
      log_type             = optional(string)
    })))
    maintenance_window_utc               = optional(string)
    name_include_app_fields              = optional(bool)
    name_infix                           = optional(bool)
    network_type                         = optional(string)
    node_type                            = optional(string)
    notification_topic_arn               = optional(string)
    num_cache_nodes                      = optional(number)
    outpost_mode                         = optional(string)
    parameter_group_name                 = optional(string)
    port                                 = optional(number)
    preferred_availability_zone_key_list = optional(list(string))
    preferred_outpost_arn                = optional(string)
    replication_group_id                 = optional(string)
    snapshot_arn                         = optional(string)
    snapshot_name                        = optional(string)
    snapshot_retention_days              = optional(number)
    snapshot_window_utc                  = optional(string)
    subnet_group_key                     = optional(bool)
    transit_encryption_enabled           = optional(string)
    vpc_az_key_list                      = optional(list(string))
    vpc_key                              = optional(string)
    vpc_security_group_key_list          = optional(list(string))
    vpc_segment_key                      = optional(string)
  }))
}

variable "cluster_apply_change_immediately_default" {
  type    = bool
  default = true
}

variable "cluster_auto_minor_version_upgrade_enabled_default" {
  type    = bool
  default = true
}

variable "cluster_availability_zone_key_default" {
  type        = string
  default     = "a"
  description = "Ignored if engine is memcached and preferred_availability_zone_key_list is provided"
}

variable "cluster_az_mode_default" {
  type        = string
  default     = "cross-az"
  description = "Ignored unless engine is redis"
  validation {
    condition     = contains(["cross-az", "single-az"], var.cluster_az_mode_default)
    error_message = "Invalid az_mode"
  }
}

variable "cluster_engine_default" {
  type    = string
  default = "redis"
  validation {
    condition     = contains(["memcached", "redis"], var.cluster_engine_default)
    error_message = "Invalid engine"
  }
}

variable "cluster_engine_version_default" {
  type    = string
  default = "7.1"
}

variable "cluster_final_snapshot_enabled_default" {
  type    = bool
  default = true
}

variable "cluster_ip_discovery_v6_default" {
  type        = bool
  default     = false
  description = "Has no effect if number of nodes is 1"
}

variable "cluster_log_map_default" {
  type = map(object({
    log_destination_name = optional(string)
    log_format           = optional(string)
    log_type             = optional(string)
  }))
  default = {
    cloudwatch-logs = {
      log_destination_name = null # Leave null to enable embedded log group
      log_format           = null
      log_type             = null
    }
  }
  description = "A map of log type to destination, where type can be 'cloudwatch-logs' or 'kinesis-firehose'. Ignored unless engine is redis."
  validation {
    condition     = length(setsubtract(keys(var.cluster_log_map_default), ["cloudwatch-logs", "kinesis-firehose"])) == 0
    error_message = "Invalid log type"
  }
}

variable "cluster_log_destination_name_default" {
  type        = string
  default     = null
  description = "A Cloudwatch log group or Kinesis Firehose. Leave null to enable embedded log group."
}

variable "cluster_log_format_default" {
  type    = string
  default = "text"
  validation {
    condition     = contains(["json", "text"], var.cluster_log_format_default)
    error_message = "Invalid log format"
  }
}

variable "cluster_log_type_default" {
  type    = string
  default = "slow-log"
  validation {
    condition     = contains(["engine-log", "slow-log"], var.cluster_log_type_default)
    error_message = "Invalid log_type"
  }
}

variable "cluster_maintenance_window_utc_default" {
  type        = string
  default     = "sun:07:00-sun:08:00"
  description = "Weekly window"
}

variable "cluster_network_type_default" {
  type    = string
  default = "dual_stack"
  validation {
    condition     = contains(["dual_stack", "ipv4", "ipv6"], var.cluster_network_type_default)
    error_message = "Invalid network type"
  }
}

variable "cluster_node_type_default" {
  type    = string
  default = "cache.t4g.micro"
}

variable "cluster_notification_topic_arn_default" {
  type    = string
  default = null
}

variable "cluster_num_cache_nodes_default" {
  type        = number
  default     = 1
  description = "Must be 1 for Redis, must be greater than 1 for Memcached and cross-az"
}

variable "cluster_outpost_mode_default" {
  type        = string
  default     = "single-outpost"
  description = "Ignored unless preferred_outpost_arn is provided"
  validation {
    condition     = contains(["cross-outpost", "single-outpost"], var.cluster_outpost_mode_default)
    error_message = "Invalid outpost_mode"
  }
}

variable "cluster_parameter_group_name_default" {
  type    = string
  default = "default.redis7"
}

variable "cluster_port_default" {
  type        = number
  default     = null
  description = "Defaults to standard port for engine"
}

variable "cluster_preferred_availability_zone_key_list_default" {
  type        = list(string)
  default     = ["a", "b"]
  description = "Ignored unless engine is memcached"
}

variable "cluster_preferred_outpost_arn_default" {
  type    = string
  default = null
}

variable "cluster_replication_group_id_default" {
  type    = string
  default = null
}

variable "cluster_snapshot_arn_default" {
  type        = string
  default     = null
  description = "Ignored unless engine is redis"
}

variable "cluster_snapshot_name_default" {
  type        = string
  default     = null
  description = "Ignored unless engine is redis"
}

variable "cluster_snapshot_retention_days_default" {
  type        = number
  default     = 1
  description = "Set nonzero to enable shapshots. No snapshots is a high severity security finding."
}

variable "cluster_snapshot_window_utc_default" {
  type        = string
  default     = "06:00-07:00"
  description = "Daily window"
}

variable "cluster_subnet_group_key_default" {
  type    = string
  default = null
}

variable "cluster_transit_encryption_enabled_default" {
  type        = bool
  default     = true
  description = "Ignored unless engine is memcached"
}

variable "name_include_app_fields_default" {
  type        = bool
  default     = true
  description = "If true, the Terraform project context will be included in the name"
}

variable "name_infix_default" {
  type    = bool
  default = true
}

variable "vpc_az_key_list_default" {
  type    = list(string)
  default = ["a", "b"]
}

variable "subnet_group_map" {
  type = map(object({
    name_effective = string
  }))
}

variable "vpc_data_map" {
  type = map(object({
    security_group_id_map = map(string)
    segment_map = map(object({
      route_public  = bool
      subnet_id_map = map(string)
      subnet_map = map(object({
        availability_zone_name = string
      }))
    }))
    vpc_cidr_block      = string
    vpc_id              = string
    vpc_ipv6_cidr_block = string
  }))
  default     = null
  description = "Must be provided if one or more "
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "vpc_security_group_key_list_default" {
  type = list(string)
  default = [
    "internal_redis_in",
  ]
}

variable "vpc_segment_key_default" {
  type    = string
  default = "internal"
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
