locals {
  dns_map = {
    for k, v in local.service_map : k => v if v.public_dns_name != null
  }
  l1_map = {
    for k, v in var.service_map : k => merge(v, module.vpc_map.data[k], {
      assign_public_ip        = v.assign_public_ip == null ? var.service_assign_public_ip_default : v.assign_public_ip
      capacity_provider_name  = v.capacity_provider_name == null ? var.service_capacity_provider_name_default : v.capacity_provider_name
      desired_count           = v.desired_count == null ? var.service_desired_count_default : v.desired_count
      ecs_cluster_id          = v.ecs_cluster_id == null ? var.service_ecs_cluster_id_default : v.ecs_cluster_id
      ecs_task_definition_arn = v.ecs_task_definition_arn == null ? var.service_ecs_task_definition_arn_default : v.ecs_task_definition_arn
      name                    = replace(k, "/[_]/", "-")
      public_dns_name         = v.public_dns_name == null ? var.service_public_dns_name_default : v.public_dns_name
      sd_namespace_id         = v.sd_namespace_id == null ? var.service_sd_namespace_id_default : v.sd_namespace_id
    })
  }
  l2_map = {
    for k, v in var.service_map : k => {
      resource_name = "${var.std_map.resource_name_prefix}${local.l1_map[k].name}${var.std_map.resource_name_suffix}"
    }
  }
  l3_map = {
    for k, v in var.service_map : k => {
      tags = merge(
        var.std_map.tags,
        {
          Name = local.l2_map[k].resource_name
        }
      )
    }
  }
  service_map = {
    for k, v in var.service_map : k => merge(local.l1_map[k], local.l2_map[k], local.l3_map[k])
  }
}
