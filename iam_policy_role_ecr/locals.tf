locals {
  repo_arn = "arn:${var.std_map.iam_partition}:ecr:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:repository/${var.repo_name}"
}
