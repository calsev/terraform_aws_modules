locals {
  output_data = {
    (var.vpc_key) = merge(
      # Drop-in replacement for vpc_data_map
      var.vpc_data_map[var.vpc_key],
      module.sg_rule.data,
      module.sg.data[var.vpc_key],
      {
        security_group_id_map = merge(
          var.vpc_data_map[var.vpc_key].security_group_id_map,
          module.sg.data[var.vpc_key].security_group_id_map,
        )
      }
    )
  }
}
