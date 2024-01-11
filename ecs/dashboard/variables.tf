variable "std_map" {
  type = object({
    aws_region_name      = string
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
