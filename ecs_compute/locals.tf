locals {
  compute_environment = merge(var.compute_environment, {
    instance_allocation_type = var.compute_environment.instance_allocation_type == null ? var.compute_environment_instance_allocation_type_default : var.compute_environment.instance_allocation_type
    instance_storage_gib     = var.compute_environment.instance_storage_gib == null ? var.compute_environment_instance_storage_gib_default : var.compute_environment.instance_storage_gib
    min_instances            = var.compute_environment.min_instances == null ? var.compute_environment_min_instances_default : var.compute_environment.min_instances
  })
  name                 = replace(var.name, "_", "-")
  resource_name        = "${var.std_map.resource_name_prefix}${local.name}${var.std_map.resource_name_suffix}"
  resource_name_prefix = "${local.resource_name}-"
  tags = merge(
    var.std_map.tags,
    {
      Name = local.resource_name
    }
  )
}
