module "name_map" {
  source                          = "../../name_map"
  name_append_default             = var.name_append_default
  name_include_app_fields_default = var.name_include_app_fields_default
  name_infix_default              = var.name_infix_default
  name_map                        = local.l0_map
  std_map                         = var.std_map
}

locals {
  l0_map = {
    for k, v in var.db_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, module.name_map.data[k], {
      bucket_name       = v.bucket_name == null ? var.db_bucket_name_default : v.bucket_name
      encryption_option = v.encryption_option == null ? var.db_encryption_option_default : v.encryption_option
      force_destroy     = v.force_destroy == null ? var.db_force_destroy_default : v.force_destroy
      kms_key_id        = v.kms_key_id == null ? var.db_kms_key_id_default : v.kms_key_id
      property_map      = v.property_map == null ? var.db_property_map_default : v.property_map
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
    }
  }
  lx_map = {
    for k, _ in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        database_id = aws_athena_database.this_db[k].id
      }
    )
  }
}
