variable "compute_arn" {
  type        = string
  description = "An ECS cluster or Batch job queue"
}

variable "cron_expression" {
  type = string
}

variable "definition_arn" {
  type        = string
  description = "An ECS task or Batch job definition"
}

variable "iam_role_arn_start_task" {
  type = string
}

variable "name" {
  type = string
}

variable "std_map" {
  type = object({
    iam_partition        = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
