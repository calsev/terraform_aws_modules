variable "secret_id" {
  type        = string
  description = "Name or ARN of the secret or parameter. Pass a resource attribute, such as the ARN of the version that holds the value, so the read waits on that resource alone; a module-wide depends_on would defer every read whenever anything in the module changes. It may be unknown at plan, so it cannot choose the data source; secret_is_param does."
}

variable "secret_is_param" {
  type        = bool
  default     = false
  description = "Read an SSM parameter rather than a Secrets Manager secret. This selects the data source through for_each, so it must be known at plan. It cannot be inferred from secret_id: the AWS provider reports the ARN of a resource being created as unknown and possibly null, and for_each then fails with Invalid for_each argument."
}

variable "secret_key" {
  type    = string
  default = null
}
