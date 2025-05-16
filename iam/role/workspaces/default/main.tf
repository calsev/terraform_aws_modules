module "this_role" {
  source                   = "../../../../iam/role/base"
  assume_role_service_list = ["workspaces"]
  name                     = "workspaces_DefaultRole"
  name_override_default    = "workspaces_DefaultRole"
  role_policy_managed_name_map_default = {
    # https://docs.aws.amazon.com/workspaces/latest/adminguide/workspaces-access-control.html#create-default-role
    self_service   = "AmazonWorkSpacesSelfServiceAccess"
    service_access = "AmazonWorkSpacesServiceAccess"
  }
  std_map = var.std_map
}
