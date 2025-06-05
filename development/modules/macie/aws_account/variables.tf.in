variable "finding_publishing_frequency" {
  type    = string
  default = "SIX_HOURS"
  validation {
    condition     = contains(["FIFTEEN_MINUTES", "ONE_HOUR", "SIX_HOURS"], var.finding_publishing_frequency)
    error_message = "Invalid passthrough behavior"
  }
}

variable "is_enabled" {
  type    = bool
  default = true
}
