variable "record_retention_period_days" {
  type        = number
  default     = 365 * 7 + 2 # Leap years
  description = "This should be set to 7 years for legal discovery"
}

variable "s3_bucket_key" {
  type = string
}

variable "s3_data_map" {
  type = map(object({
    name_effective = string
  }))
}

{{ std.map() }}
