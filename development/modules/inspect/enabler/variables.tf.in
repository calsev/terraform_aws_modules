variable "enabler_map" {
  type = map(object({
    aws_account_id_list = optional(list(string))
    {{ name.var_item() }}
    resource_type_list  = optional(list(string))
  }))
}

variable "enabler_aws_account_id_list_default" {
  type        = list(string)
  default     = null
  description = "Defaults to current account"
}

variable "enabler_resource_type_list_default" {
  type    = list(string)
  default = ["EC2", "ECR", "LAMBDA", "LAMBDA_CODE"]
  validation {
    condition     = length(setsubtract(toset(var.enabler_resource_type_list_default), toset(["EC2", "ECR", "LAMBDA", "LAMBDA_CODE"]))) == 0
    error_message = "Invalid resource types"
  }
}

{{ name.var() }}

{{ std.map() }}
