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
      vpc_link_id          = optional(string)
    }))
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
}

variable "integration_service_default" {
  type    = string
  default = null
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

variable "integration_vpc_link_id_default" {
  type    = string
  default = null
}

variable "std_map" {
  type = object({
    aws_region_name      = string
    iam_partition        = string
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
