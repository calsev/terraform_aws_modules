data "terraform_remote_state" "dns" {
  backend = "s3"
  config = {
    bucket = "example-deploy"
    key    = "tf-backend/inf-dns.tfstate"
    region = local.std_var.aws_region_name
  }
}

data "terraform_remote_state" "monitor" {
  backend = "s3"
  config = {
    bucket = "example-deploy"
    key    = "tf-backend/inf-monitor.tfstate"
    region = local.std_var.aws_region_name
  }
}

data "terraform_remote_state" "s3" {
  backend = "s3"
  config = {
    bucket = "example-deploy"
    key    = "tf-backend/inf-s3.tfstate"
    region = local.std_var.aws_region_name
  }
}
