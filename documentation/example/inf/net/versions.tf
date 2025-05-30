terraform {
  backend "s3" {
    bucket       = "example-deploy"
    encrypt      = true
    key          = "tf-backend/inf-net.tfstate"
    region       = "us-west-2"
    use_lockfile = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  required_version = ">= 1.3"
}
