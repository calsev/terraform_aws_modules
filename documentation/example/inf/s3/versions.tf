terraform {
  backend "s3" {
    bucket         = "example-deploy"
    dynamodb_table = "terraform-locks" # This must be created point-and-click and imported
    encrypt        = true
    key            = "tf-backend/inf-s3.tfstate"
    region         = "us-west-2"
    use_lockfile   = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  required_version = ">= 1.3"
}
