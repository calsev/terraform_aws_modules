locals {
  output_data = {
    role = module.service_role.data["config"]
  }
}
