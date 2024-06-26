terraform {
  required_providers {
    aws = { # tflint-ignore: terraform_unused_required_providers
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.0"
    }
  }
  required_version = ">= 1.3"
}
