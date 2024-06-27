module "service_role" {
  source = "../../iam/role/service_linked"
  service_map = {
    config = {}
  }
  std_map = var.std_map
}

resource "aws_config_retention_configuration" "this_retention" {
  retention_period_in_days = var.record_retention_period_days
}
