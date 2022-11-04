locals {
  batch_is_spot = local.compute_environment.instance_allocation_type == "SPOT"
  compute_environment = merge(var.compute_environment, {
    instance_allocation_type = var.compute_environment.instance_allocation_type == null ? var.compute_environment_instance_allocation_type_default : var.compute_environment.instance_allocation_type
    instance_storage_gib     = var.compute_environment.instance_storage_gib == null ? var.compute_environment_instance_storage_gib_default : var.compute_environment.instance_storage_gib
    min_vcpus                = var.compute_environment.min_vcpus == null ? var.compute_environment_min_vcpus_default : var.compute_environment.min_vcpus
  })
  instance_family_is_gpu = {
    a1   = false
    g4dn = true
    t3a  = false
    t4g  = false
    m5a  = false
    p3   = true
  }
  image_type           = local.instance_family_is_gpu[module.compute_common.data.instance_family] ? "ECS_AL2_NVIDIA" : "ECS_AL2"
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
