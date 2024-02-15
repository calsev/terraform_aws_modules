module "this_policy" {
  source      = "../../../../../iam/policy/identity/access_resource"
  access_list = var.access_list
  name        = var.name
  name_infix  = var.name_infix
  name_prefix = var.name_prefix
  resource_map = {
    event-bus = [local.bus_arn]
    star      = ["*"]
  }
  service_name = "events"
  std_map      = var.std_map
}
