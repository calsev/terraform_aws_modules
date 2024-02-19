variable "std_map" {
  type = object({
    aws_account_id       = string
    aws_region_name      = string
    iam_partition        = string
    name_replace_regex   = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
