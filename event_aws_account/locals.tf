locals {
  output_data = {
    bus = module.default_event_bus.data
  }
  source_account_condition = {
    test       = "StringEquals"
    value_list = [var.std_map.aws_account_id]
    variable   = "AWS:SourceAccount"
  }
}