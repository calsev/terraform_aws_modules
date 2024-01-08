terraform {
  backend "s3" {
    bucket         = "example-deploy"
    dynamodb_table = "terraform-locks"
    encrypt        = true
    key            = "tf-backend/app-lambda.tfstate"
    region         = "us-west-2"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  required_version = ">= 1.3"
}
