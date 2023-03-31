module "name_map" {
  source   = "../name_map"
  name_map = var.service_map
  std_map  = var.std_map
}

locals {
  dns_map = {
    for k, v in local.service_map : k => v if v.public_dns_name != null
  }
  l1_map = {
    for k, v in var.service_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      assign_public_ip        = v.assign_public_ip == null ? var.service_assign_public_ip_default : v.assign_public_ip
      capacity_provider_name  = v.capacity_provider_name == null ? var.service_capacity_provider_name_default : v.capacity_provider_name
      desired_count           = v.desired_count == null ? var.service_desired_count_default : v.desired_count
      ecs_cluster_id          = v.ecs_cluster_id == null ? var.service_ecs_cluster_id_default : v.ecs_cluster_id
      ecs_task_definition_arn = v.ecs_task_definition_arn == null ? var.service_ecs_task_definition_arn_default : v.ecs_task_definition_arn
      public_dns_name         = v.public_dns_name == null ? var.service_public_dns_name_default : v.public_dns_name
      sd_namespace_id         = v.sd_namespace_id == null ? var.service_sd_namespace_id_default : v.sd_namespace_id
    })
  }
  service_map = {
    for k, v in var.service_map : k => merge(local.l1_map[k])
  }
}
