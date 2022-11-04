locals {
  report_group_key = var.build_project_name == null ? "*" : "${var.build_project_name}-*"
}
