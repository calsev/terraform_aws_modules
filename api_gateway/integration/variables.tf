variable "api_map" {
  type = map(object({
    api_id                           = string
    integration_iam_role_arn_default = optional(string)
    integration_map = map(object({
      http_method          = optional(string) # Ignored for sqs, states
      iam_role_arn         = optional(string)
      passthrough_behavior = optional(string)
      request_parameters   = optional(map(string)) # Defaults provided for sqs, states
      service              = optional(string)
      subtype              = optional(string)
      target_arn           = optional(string) # Used for states, ignored for lambda, sqs
      target_uri           = optional(string) # Used for lambda, sqs, ignored for states
      timeout_seconds      = optional(number)
      type                 = optional(string)
      vpc_link_id          = optional(string)
    }))
    integration_service_default = optional(string)
  }))
}

variable "integration_http_method_default" {
  type        = string
  default     = "POST"
  description = "Ignored for integrations with subtype, e.g. SQS, StepFunctions"
}

variable "integration_iam_role_arn_default" {
  type    = string
  default = null
}

variable "integration_passthrough_behavior_default" {
  type    = string
  default = "WHEN_NO_MATCH"
  validation {
    condition     = contains(["NEVER", "WHEN_NO_MATCH", "WHEN_NO_TEMPLATES"], var.integration_passthrough_behavior_default)
    error_message = "Invalid passthrough behavior"
  }
}

variable "integration_subtype_map_default" {
  type = map(string)
  default = {
    appconfig = "AppConfig-GetConfiguration"
    events    = "EventBridge-PutEvents"
    kinesis   = "Kinesis-PutRecord"
    sqs       = "SQS-SendMessage"
    states    = "StepFunctions-StartExecution"

  }
  description = "If no subtype is mapped, the target_uri must be provided (Lambda). See https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-develop-integrations-aws-services-reference.html."
}

variable "integration_timeout_seconds_default" {
  type    = number
  default = null
}

variable "integration_type_default" {
  type    = string
  default = "AWS_PROXY"
  validation {
    condition     = contains(["AWS_PROXY", "HTTP_PROXY"], var.integration_type_default)
    error_message = "HTTP APIs support only proxy integrations"
  }
}

variable "integration_vpc_link_id_default" {
  type    = string
  default = null
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
