data "aws_vpc" "this_vpc" {
  id = var.vpc_id
}

data "aws_subnets" "this_subnet" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name   = "tag:Name"
    values = ["*${var.subnet_filter_tag}*"]
  }
}
