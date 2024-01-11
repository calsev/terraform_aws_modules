variable "setting_map" {
  type = object({
    awsvpcTrunking                 = optional(bool, true)
    containerInstanceLongArnFormat = optional(bool, true)
    containerInsights              = optional(bool, true)
    serviceLongArnFormat           = optional(bool, true)
    taskLongArnFormat              = optional(bool, true)
  })
  default = {
    awsvpcTrunking                 = true
    containerInstanceLongArnFormat = true
    containerInsights              = true
    serviceLongArnFormat           = true
    taskLongArnFormat              = true
  }
}
