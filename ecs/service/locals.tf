module "name_map" {
  source   = "../../name_map"
  name_map = var.service_map
  std_map  = var.std_map
}

locals {
  l1_map = {
    for k, v in var.service_map : k => merge(v, module.name_map.data[k], module.vpc_map.data[k], {
      desired_count           = v.desired_count == null ? var.service_desired_count_default : v.desired_count
      ecs_cluster_key         = v.ecs_cluster_key == null ? var.service_ecs_cluster_key_default == null ? k : var.service_ecs_cluster_key_default : v.ecs_cluster_key
      ecs_task_definition_arn = v.ecs_task_definition_arn == null ? var.service_ecs_task_definition_arn_default : v.ecs_task_definition_arn
      sd_namespace_key        = v.sd_namespace_key == null ? var.service_sd_namespace_key_default : v.sd_namespace_key
    })
  }
  l2_map = {
    for k, v in var.service_map : k => {
      assign_public_ip       = var.ecs_cluster_data[local.l1_map[k].ecs_cluster_key].capability_type == "EC2" ? false : v.assign_public_ip == null ? var.service_assign_public_ip_default == null ? local.l1_map[k].vpc_segment_route_public : var.service_assign_public_ip_default : v.assign_public_ip
      capacity_provider_name = var.ecs_cluster_data[local.l1_map[k].ecs_cluster_key].capacity_provider_name
      ecs_cluster_id         = var.ecs_cluster_data[local.l1_map[k].ecs_cluster_key].ecs_cluster_id
      placement_constraint_list = var.ecs_cluster_data[local.l1_map[k].ecs_cluster_key].capability_type == "FARGATE" ? [] : [
        {
          field = "attribute:ecs.availability-zone"
          type  = "spread"
        },
        {
          field = "instanceId"
          type  = "spread"
        },
      ]
      sd_namespace_id = v.sd_hostname == null ? null : var.dns_data.domain_to_sd_zone_map[local.l1_map[k].sd_namespace_key].id
    }
  }
  output_data = {
    for k, v in local.service_map : k => merge(v, {
      dns_name     = v.sd_hostname == null ? null : "${v.sd_hostname}.${v.sd_namespace_key}"
      service_name = aws_ecs_service.this_service[k].name
    })
  }
  sd_map = {
    for k, v in local.service_map : k => v if v.sd_hostname != null
  }
  service_map = {
    for k, v in var.service_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
}
