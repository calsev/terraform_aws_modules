locals {
  output_data = module.this_policy.data[var.name]
  lx_map = {
    (var.name) = {
      iam_policy_json = data.aws_iam_policy_document.network_policy.json
      {{ name.map_item() }}
    }
  }
}
