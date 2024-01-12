data "terraform_remote_state" "dns" {
  backend = "s3"

  config = {
    bucket = "example-deploy"
    key    = "tf-backend/inf-dns.tfstate"
    region = "us-west-2"
  }
}
