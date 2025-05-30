module "host" {
  source                              = "../../../ci_cd/remote/host"
  host_map                            = var.host_map
  host_provider_type_default          = var.host_provider_type_default
  host_vpc_tls_certificate_default    = var.host_vpc_tls_certificate_default
  std_map                             = var.std_map
  vpc_az_key_list_default             = var.vpc_az_key_list_default
  vpc_data_map                        = var.vpc_data_map
  vpc_key_default                     = var.vpc_key_default
  vpc_security_group_key_list_default = var.vpc_security_group_key_list_default
  vpc_segment_key_default             = var.vpc_segment_key_default
}

module "connection" {
  source                           = "../../../ci_cd/remote/connection"
  connection_map                   = var.connection_map
  connection_host_key_default      = var.connection_host_key_default
  connection_provider_type_default = var.connection_provider_type_default
  host_data_map                    = module.host.data
  {{ iam.policy_map_item_ar() }}
  std_map                          = var.std_map
}
