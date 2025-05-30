variable "ecr_data" {
  type = object({
    repo_map = map(object({
      policy_map = map(object({
        iam_policy_arn = string
      }))
      repo_url = string
    }))
  })
  default     = null
  description = "Must be provided if any function is configured with an image"
}

variable "function_map" {
  type = map(object({
    architecture_list                                = optional(list(string))
    code_signing_config_arn                          = optional(string)
    dead_letter_queue_enabled                        = optional(bool)
    environment_variable_map                         = optional(map(string))
    ephemeral_storage_mib                            = optional(number)
    kms_key_arn                                      = optional(string)
    layer_version_arn_list                           = optional(list(string))
    memory_size_mib                                  = optional(number)
    {{ name.var_item() }}
    policy_access_list                               = optional(list(string))
    policy_create                                    = optional(bool)
    policy_name_append                               = optional(string)
    publish_numbered_version                         = optional(bool)
    reserved_concurrent_executions                   = optional(number)
    {{ iam.role_var_item() }}
    source_content_path_of_file_to_create_in_archive = optional(string)
    source_content_local_path                        = optional(string)
    source_content_string                            = optional(string)
    source_image_command                             = optional(list(string))
    source_image_entry_point                         = optional(list(string))
    source_image_repo_key                            = optional(string)
    source_image_repo_tag                            = optional(string)
    source_image_working_directory                   = optional(string)
    source_package_archive_local_path                = optional(string)
    source_package_created_archive_path              = optional(string) # Defaults to the directory with .zip appended or content file parent with pakage.zip appended
    source_package_directory_local_path              = optional(string)
    source_package_handler                           = optional(string) # Also used for source_content
    source_package_runtime                           = optional(string)
    source_package_s3_bucket_name                    = optional(string)
    source_package_s3_object_hash                    = optional(string) # TODO: Calc for local, this for S3
    source_package_s3_object_key                     = optional(string) # Defaults to ${var.function_source_package_s3_object_key_base_default}/deployment_package_${key}zip
    source_package_s3_object_version                 = optional(number)
    source_package_snap_start_enabled                = optional(bool)
    timeout_seconds                                  = optional(number)
    tracing_mode                                     = optional(string)
    vpc_az_key_list                                  = optional(list(string))
    vpc_ipv6_allowed                                 = optional(bool)
    vpc_key                                          = optional(string)
    vpc_security_group_key_list                      = optional(list(string))
    vpc_segment_key                                  = optional(string)
  }))
}

variable "function_architecture_list_default" {
  type        = list(string)
  default     = ["arm64"]
  description = "Also valid is ['x86_64']"
}

variable "function_code_signing_config_arn_default" {
  type    = string
  default = null
}

variable "function_dead_letter_queue_enabled_default" {
  type    = bool
  default = true
}

variable "function_environment_variable_map_default" {
  type    = map(string)
  default = {}
}

variable "function_ephemeral_storage_mib_default" {
  type        = number
  default     = null
  description = "Must be >= 512 if using an image or an s3 package"
}

variable "function_kms_key_arn_default" {
  type    = string
  default = null
}

variable "function_layer_version_arn_list_default" {
  type    = list(string)
  default = []
}

variable "function_memory_size_mib_default" {
  type    = number
  default = 128
}

variable "function_publish_numbered_version_default" {
  type    = bool
  default = false
}

variable "function_reserved_concurrent_executions_default" {
  type    = number
  default = -1
}

variable "function_source_content_path_of_file_to_create_in_archive_default" {
  type        = string
  default     = null
  description = "Defaults to basename of source_content_local_path"
}

variable "function_source_content_local_path_default" {
  type    = string
  default = null
}

variable "function_source_content_string_default" {
  type    = string
  default = null
}

variable "function_source_image_command_default" {
  type    = list(string)
  default = null
}

variable "function_source_image_entry_point_default" {
  type    = list(string)
  default = null
}

variable "function_source_image_repo_key_default" {
  type    = string
  default = null
}

variable "function_source_image_repo_tag_default" {
  type    = string
  default = "latest"
}

variable "function_source_image_working_directory_default" {
  type    = string
  default = null
}

variable "function_source_package_archive_local_path_default" {
  type        = string
  default     = null
  description = "Overrides a local directory or S3 object"
}

variable "function_source_package_directory_local_path_default" {
  type        = string
  default     = null
  description = "Ignored if an archive path is provided. Overrides an S3 object."
}

variable "function_source_package_handler_default" {
  type    = string
  default = null
}

variable "function_source_package_s3_object_hash_default" {
  type        = string
  default     = null
  description = "Ignored if image key is provided or an archive or directory is provided"
}

variable "function_source_package_runtime_default" {
  type        = string
  default     = null
  description = "Ignored if image key is provided. See https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime for valid options"
}

variable "function_source_package_s3_bucket_name_default" {
  type        = string
  default     = null
  description = "If no local path is provided, the object must exist in S3. Otherwise optionally provide bucket and key to create an S3 object."
}

variable "function_source_package_s3_object_key_base_default" {
  type        = string
  default     = "lambda_function"
  description = "Used a a base path segment for default S3 paths. If no local path is provided, the object must exist in S3. Otherwise optionally provide bucket and key to create an S3 object."
}

variable "function_source_package_s3_object_version_default" {
  type        = number
  default     = null
  description = "Ignored if an archive or directory is provided"
}

variable "function_package_snap_start_enabled_default" {
  type        = bool
  default     = true
  description = "Ignored except for Java source_package_runtime"
}

variable "function_timeout_seconds_default" {
  type    = number
  default = 3
}

variable "function_tracing_mode_default" {
  type    = string
  default = null
}

variable "function_vpc_ipv6_allowed_default" {
  type        = bool
  default     = true
  description = "Ignored for functions not in VPC"
}

variable "iam_data" {
  type = object({
    iam_policy_arn_lambda_vpc = string
  })
  default     = null
  description = "Must be provided if any function is configured in a VPC"
}

{{ name.var() }}

{{ iam.policy_var_ar(access=["write"]) }}

{{ iam.role_var() }}

{{ std.map() }}

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
  default     = null
  description = "Must be provided if any function is configured in a VPC"
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
