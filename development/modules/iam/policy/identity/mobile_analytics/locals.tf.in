locals {
  output_data = module.this_policy.data[var.name]
  lx_map = {
    (var.name) = {
      {{ name.map_item() }}
      resource_map = {
        star = ["*"]
      }
    }
  }
}
