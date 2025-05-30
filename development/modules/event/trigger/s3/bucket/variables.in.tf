variable "event_map" {
  type = map(object({
    dead_letter_queue_enabled         = optional(bool)
    definition_arn                    = optional(string)
    iam_role_arn_custom               = optional(string)
    iam_role_use_custom               = optional(bool)
    input_path                        = optional(string)
    input_transformer_path_map        = optional(map(string))
    input_transformer_template_json   = optional(string)
    input_transformer_template_string = optional(string)
    is_enabled                        = optional(bool)
    {{ name.var_item() }}
    retry_attempts                    = optional(number)
    {{ iam.role_var_item() }}
    s3_bucket_name                    = optional(string)
    s3_object_key_prefix_list         = optional(list(string))
    s3_object_key_suffix_list         = optional(list(string))
    target_arn                        = optional(string)
    target_service                    = optional(string)
    task_count                        = optional(number)
    vpc_az_key_list                   = optional(list(string))
    vpc_key                           = optional(string)
    vpc_security_group_key_list       = optional(list(string))
    vpc_segment_key                   = optional(string)
  }))
}

variable "event_dead_letter_queue_enabled_default" {
  type        = bool
  default     = true
  description = "Ignored if the target is a log group or sns topic"
}

variable "event_definition_arn_default" {
  type        = string
  default     = null
  description = "An ECS task or Batch job definition, if relevant"
}

variable "event_iam_role_arn_custom_default" {
  type        = string
  default     = null
  description = "By default, a policy is created that allows running the target and sending messages to the dead letter queue. Account for these actions when using a custom policy. Ignored if the target is a log group."
}

variable "event_iam_role_use_custom_default" {
  type        = bool
  default     = false
  description = "This is required so that the set of resources does not depend on state, as it typically would with role ARNs"
}

variable "event_input_path_default" {
  type    = string
  default = null
}

variable "event_input_transformer_path_map_default" {
  type = map(string)
  default = {
    # https://docs.aws.amazon.com/AmazonS3/latest/userguide/notification-content-structure.html
    bucket_name = "$.detail.bucket.name"
    object_key  = "$.detail.object.key"
  }
}

variable "event_input_transformer_template_json_default" {
  type        = string
  default     = null
  description = "If an input path is provided, defaults to a simple map of the inputs. Not used if a template string is provided"
}

variable "event_input_transformer_template_string_default" {
  type        = string
  default     = null
  description = "If provided, will be used as a template string"
}

variable "event_is_enabled_default" {
  type    = bool
  default = true
}

variable "event_retry_attempts_default" {
  type        = number
  default     = 0
  description = "Number of retries for Batch jobs"
}

variable "event_s3_bucket_name_default" {
  type    = string
  default = null
}

variable "event_s3_object_key_prefix_list_default" {
  type    = list(string)
  default = []
}

variable "event_s3_object_key_suffix_list_default" {
  type    = list(string)
  default = null
}

variable "event_target_arn_default" {
  type        = string
  default     = null
  description = "An ECS cluster, Batch job queue, Cloudwatch log group, SNS topic ..."
}

variable "event_target_service_default" {
  type        = string
  default     = null
  description = "This is required so that the set of resources does not depend on state, as it typically would with target and definition ARNs"
  validation {
    condition     = var.event_target_service_default == null ? true : contains(["batch", "ecs", "events", "logs", "sns"], var.event_target_service_default)
    error_message = "Invalid target service"
  }
}

variable "event_task_count_default" {
  type        = number
  default     = 1
  description = "Number of Batch jobs or ECS tasks to launch"
}

variable "iam_data" {
  type = object({
    iam_policy_arn_batch_submit_job = string
    iam_policy_arn_ecs_start_task   = string
  })
  default     = null
  description = "Must be provided for Batch and ECS targets"
}

{{ name.var() }}

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
  description = "Required for ECS targets"
}

variable "vpc_key_default" {
  type    = string
  default = null
}

variable "vpc_security_group_key_list_default" {
  type = list(string)
  default = [
    "world_all_out",
  ]
}

variable "vpc_segment_key_default" {
  type    = string
  default = "internal"
}
