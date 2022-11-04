variable "std_var" {
  type = object({
    app             = string
    aws_account_id  = optional(string)
    aws_region_name = string
    env             = string
    iam_partition   = optional(string)
  })
}

variable "tags" {
  type = map(string)
  default = {
  }
}
