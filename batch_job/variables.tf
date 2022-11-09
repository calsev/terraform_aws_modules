variable "job_map" {
  type = map(object({
    command_list               = optional(list(string))
    iam_role_arn_job_container = optional(string)
    iam_role_arn_job_execution = optional(string)
    image_id                   = optional(string)
    image_tag                  = optional(string)
    memory_gib                 = optional(number)
    number_of_cpu              = optional(number)
    number_of_gpu              = optional(number)
    shared_memory_gib          = optional(number)
  }))
}

variable "job_command_list_default" {
  type    = list(string)
  default = ["echo", "Hello World!"]
}

variable "job_iam_role_arn_job_container_default" {
  type    = string
  default = null
}

variable "job_iam_role_arn_job_execution_default" {
  type    = string
  default = null
}

variable "job_image_id_default" {
  type    = string
  default = "public.ecr.aws/ubuntu/ubuntu"
}

variable "job_image_tag_default" {
  type    = string
  default = "22.04"
}

variable "job_memory_gib_default" {
  type    = number
  default = null
}

variable "job_number_of_cpu_default" {
  type    = number
  default = null
}

variable "job_number_of_gpu_default" {
  type    = number
  default = 0
}

variable "job_shared_memory_gib_default" {
  type    = number
  default = null
}

variable "std_map" {
  type = object({
    resource_name_prefix = string
    resource_name_suffix = string
    tags                 = map(string)
  })
}
