variable "action_list" {
  type        = list(string)
  default     = null
  description = "https://docs.aws.amazon.com/AmazonS3/latest/userguide/EventBridge.html. Set null to disable. If used, account for PutObject, CompleteMultipartUpload, etc."
}

variable "aws_account_id" {
  type        = string
  default     = null
  description = "If provided, will override current account"
}

variable "bucket_name" {
  type = string
}

variable "detail_type_list" {
  type        = list(string)
  default     = ["Object Created"]
  description = "https://docs.aws.amazon.com/AmazonS3/latest/userguide/EventBridge.html. Set null to disable."
}

variable "object_key_is_prefix" {
  type        = bool
  default     = true
  description = "Set false for suffix matching"
}

variable "object_key_list" {
  type        = list(string)
  default     = []
  description = "This should not start with a slash."
}

variable "std_map" {
  type = object({
    aws_account_id = string
  })
}
