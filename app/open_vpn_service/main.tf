module "secret" {
  source                                      = "../../secret/random"
  name_append_default                         = var.name_append_default
  name_include_app_fields_default             = var.name_include_app_fields_default
  name_infix_default                          = var.name_infix_default
  name_prefix_default                         = var.name_prefix_default
  name_prepend_default                        = var.name_prepend_default
  name_suffix_default                         = var.name_suffix_default
  secret_is_param_default                     = var.secret_is_param_default
  secret_map                                  = local.lx_map
  secret_random_init_key_default              = var.secret_random_init_key_default
  secret_random_init_map_default              = var.secret_random_init_map_default
  secret_random_init_value_map                = var.secret_random_init_value_map
  secret_random_special_character_set_default = var.secret_random_special_character_set_default
  std_map                                     = var.std_map
}

module "instance_role" {
  source                          = "../../iam/role/ec2/instance"
  for_each                        = local.lx_map
  monitor_data                    = var.monitor_data
  name                            = "${each.key}_instance"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  role_policy_attach_arn_map_default = {
    ec2_attribute_modify = var.iam_data.iam_policy_arn_ec2_modify_attribute
  }
  std_map = var.std_map
}

module "ecs_task_execution_role" {
  source                          = "../../iam/role/ecs/task_execution"
  for_each                        = local.lx_map
  iam_data                        = var.iam_data
  name                            = "${each.key}_execution"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_prefix_default             = var.name_prefix_default
  name_prepend_default            = var.name_prepend_default
  name_suffix_default             = var.name_suffix_default
  role_policy_attach_arn_map_default = {
    openvpn_secret_read = module.secret.data[each.key].policy_map["read"].iam_policy_arn
  }
  std_map = var.std_map
}

module "efs" {
  source = "../../efs"
  fs_access_point_map_default = {
    "/openvpn" = {
      permission_mode = "1777"
    }
  }
  fs_map                              = local.lx_map
  std_map                             = var.std_map
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_data_map                        = var.vpc_data_map
  vpc_key_default                     = var.vpc_key_default
  vpc_segment_key_default             = var.vpc_segment_key_default
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_efs_default
}

module "ecs_app" {
  source                                      = "../../app/ecs_app"
  app_map                                     = local.create_app_map
  app_path_terraform_app_to_repo_root_default = "../../../../.."
  build_image_ecr_repo_key_default            = var.build_image_ecr_repo_key_default
  build_image_tag_base_default                = var.build_image_tag_base_default
  build_role_policy_attach_arn_map_default    = var.build_role_policy_attach_arn_map_default
  build_role_policy_create_json_map_default   = var.build_role_policy_create_json_map_default
  build_role_policy_inline_json_map_default   = var.build_role_policy_inline_json_map_default
  build_role_policy_managed_name_map_default  = var.build_role_policy_managed_name_map_default
  build_source_build_spec_image_default       = var.build_source_build_spec_image_default
  build_source_build_spec_manifest_default    = var.build_source_build_spec_manifest_default
  ci_cd_account_data                          = var.ci_cd_account_data
  ci_cd_build_data_map                        = {}
  compute_instance_type_default               = var.compute_instance_type_default
  compute_user_data_command_list_default = [
    "TOKEN=$(curl -X PUT 'http://169.254.169.254/latest/api/token' -H 'X-aws-ec2-metadata-token-ttl-seconds: 21600')",
    "EC2_INSTANCE_ID=$(curl -H \"X-aws-ec2-metadata-token: $TOKEN\" -s http://169.254.169.254/latest/meta-data/instance-id)",
    "aws ec2 modify-instance-attribute --region ${var.std_map.aws_region_name} --no-source-dest-check --instance-id $EC2_INSTANCE_ID",
  ]
  dns_data                                     = var.dns_data
  ecr_data_map                                 = var.ecr_data_map
  listener_dns_alias_enabled_default           = var.listener_dns_alias_enabled_default
  listener_dns_from_zone_key_default           = var.listener_dns_from_zone_key_default
  elb_data_map                                 = var.elb_data_map
  iam_data                                     = var.iam_data
  monitor_data                                 = var.monitor_data
  pipe_build_artifact_name_default             = "SourceArtifact" # TODO: Test
  pipe_source_branch_default                   = var.pipe_source_branch_default
  pipe_source_code_star_connection_key_default = var.pipe_source_code_star_connection_key_default
  pipe_source_repository_id_default            = var.pipe_source_repository_id_default
  pipe_webhook_enabled_default                 = var.pipe_webhook_enabled_default
  service_desired_count_default                = var.service_desired_count_default
  std_map                                      = var.std_map
  service_elb_target_container_name_default    = "server"
  target_type_default                          = "instance" # For host networking
  task_container_environment_map_default = {
  }
  task_container_linux_capability_add_list_default = [
    "MKNOD",
    "NET_ADMIN",
  ]
  task_container_linux_device_permission_list_default = [
    "read",
    "write",
  ]
  task_container_mount_point_map_default = {
    openvpn = {}
    tmp     = {}
    usr_local_openvpn_as = {
      container_path = "/usr/local/openvpn_as"
    }
    var_log = {}
    var_run = {}
  }
  task_docker_volume_map_default = {
    tmp                  = {}
    usr_local_openvpn_as = {}
    var_log              = {}
    var_run              = {}
  }
  task_network_mode_default           = "host"
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_data_map                        = var.vpc_data_map
  vpc_key_default                     = var.vpc_key_default
  vpc_segment_key_default             = var.vpc_segment_key_default
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_instance_default
}

resource "local_file" "docker_compose" {
  for_each = local.create_file_map
  content = templatefile("${path.module}/app/docker/docker_compose.yml", {
  })
  filename        = "${each.value.path_terraform_app_to_app_directory}/docker/docker_compose.yml"
  file_permission = "0644"
}

resource "local_file" "dockerfile" {
  for_each = local.create_file_map
  content = templatefile("${path.module}/app/docker/Dockerfile", {
    image_source_uri = each.value.image_source_uri
  })
  filename        = "${each.value.path_terraform_app_to_app_directory}/docker/Dockerfile"
  file_permission = "0644"
}

resource "local_file" "entry_point" {
  for_each = local.create_file_map
  content = templatefile("${path.module}/app/docker/entry_point.sh", {
  })
  filename        = "${each.value.path_terraform_app_to_app_directory}/docker/entry_point.sh"
  file_permission = "0644"
}

resource "local_file" "image_build_spec" {
  for_each = local.create_file_map
  content = templatefile("${path.module}/app/spec/image_build.yml", {
    path_repo_root_to_app_directory = each.value.path_repo_root_to_app_directory
  })
  filename        = "${each.value.path_terraform_app_to_app_directory}/spec/image_build.yml"
  file_permission = "0644"
}

resource "local_file" "image_manifest_spec" {
  for_each = local.create_file_map
  content = templatefile("${path.module}/app/spec/image_manifest.yml", {
    path_repo_root_to_app_directory = each.value.path_repo_root_to_app_directory
  })
  filename        = "${each.value.path_terraform_app_to_app_directory}/spec/image_manifest.yml"
  file_permission = "0644"
}

resource "local_file" "makefile" {
  for_each = local.create_file_map
  content = templatefile("${path.module}/app/Makefile", {
    aws_region_name = var.std_map.aws_region_name
    ecr_repo_url    = each.value.ecr_repo_url
    image_tag_base  = each.value.image_tag_base
  })
  filename        = "${each.value.path_terraform_app_to_app_directory}/Makefile"
  file_permission = "0644"
}
