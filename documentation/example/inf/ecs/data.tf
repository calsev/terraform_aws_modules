data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = "example-deploy"
    key    = "tf-backend/inf-iam.tfstate"
    region = local.aws_region_name
  }
}

data "terraform_remote_state" "monitor" {
  backend = "s3"
  config = {
    bucket = "example-deploy"
    key    = "tf-backend/inf-monitor.tfstate"
    region = local.aws_region_name
  }
}

data "terraform_remote_state" "net" {
  backend = "s3"
  config = {
    bucket = "example-deploy"
    key    = "tf-backend/inf-net.tfstate"
    region = local.aws_region_name
  }
}
