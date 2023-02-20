variable "action_list" {
  type = list(string)
  default = [
    "PutObject",
  ]
}

variable "aws_account_id" {
  type        = string
  default     = null
  description = "If provided, will override current account"
}

variable "bucket_name" {
  type = string
}

variable "object_key_prefix" {
  type    = string
  default = "/"
}

variable "object_key_suffix" {
  type    = string
  default = null
}

variable "std_map" {
  type = object({
    aws_account_id = string
  })
}
