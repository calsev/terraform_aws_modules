data "terraform_remote_state" "cdn_global" {
  backend = "s3"

  config = {
    bucket = "example-deploy"
    key    = "tf-backend/inf-cdn-global.tfstate"
    region = local.std_var.aws_region_name
  }
}

data "terraform_remote_state" "dns" {
  backend = "s3"

  config = {
    bucket = "example-deploy"
    key    = "tf-backend/inf-dns.tfstate"
    region = local.std_var.aws_region_name
  }
}

data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = "example-deploy"
    key    = "tf-backend/inf-iam.tfstate"
    region = local.std_var.aws_region_name
  }
}
