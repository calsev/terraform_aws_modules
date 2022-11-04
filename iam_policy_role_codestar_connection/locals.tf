locals {
  resource_connection_map = {
    connection = var.connection_arn != null ? [var.connection_arn] : ["arn:${var.std_map.iam_partition}:codestar-connections:${var.std_map.aws_region_name}:${var.std_map.aws_account_id}:connection/*"]
    star       = ["*"]
  }
  resource_map = var.connection_host_arn == null || var.connection_host_arn == "" ? tomap(local.resource_connection_map) : tomap(merge(local.resource_connection_map, {
    host = [var.connection_host_arn]
  }))
}
