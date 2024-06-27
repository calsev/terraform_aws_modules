variable "support_account_id_list" {
  type        = list(string)
  default     = []
  description = "The current account will be appended"
}

variable "std_map" {
  type = object({
    aws_account_id       = string
    iam_partition        = string
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
