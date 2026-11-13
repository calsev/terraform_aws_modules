terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0" # region arguments
    }
  }
  required_version = ">= 1.3"
}
