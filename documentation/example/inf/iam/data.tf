data "terraform_remote_state" "monitor" {
  backend = "s3"
  config = {
    bucket = "example-deploy"
    key    = "tf-backend/inf-monitor.tfstate"
    region = local.std_var.aws_region_name
  }
}
