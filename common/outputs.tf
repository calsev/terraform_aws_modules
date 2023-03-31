output "std_map" {
  value = {
    app                            = var.std_var.app
    access_title_map               = local.access_title_map
    aws_account_id                 = var.std_var.aws_account_id == null ? data.aws_caller_identity.current.account_id : var.std_var.aws_account_id
    aws_region_abbreviation        = local.aws_region_abbreviation
    aws_region_name                = var.std_var.aws_region_name
    collaborator_map               = local.collaborator_map
    config_name                    = local.config_name
    config_name_suffix             = local.config_name_suffix
    env                            = var.std_var.env
    iam_partition                  = local.iam_partition
    name_context                   = local.name_context
    resource_name_prefix           = local.resource_name_prefix
    resource_name_suffix           = local.resource_name_suffix
    service_resource_access_action = local.service_resource_access_action
    tags                           = local.tags
    workspace_suffix               = local.workspace_suffix
  }
}
