module "password_secret" {
  source                          = "../../secret/random"
  name_include_app_fields_default = false
  secret_map                      = local.create_password_map
  secret_random_init_key_default  = "password"
  std_map                         = var.std_map
}

# The AWS provider has no resource for Directory Service Data users, so user.sh calls the CLI.
# It runs on create and destroy only: the password is an initial one, and attributes are set once.
resource "terraform_data" "this_user" {
  # The ARN alone does not wait for the initial secret value that user.sh reads.
  depends_on = [module.password_secret]
  for_each   = local.lx_map
  input = {
    directory_id = each.value.directory_id
    region       = var.std_map.aws_region_name
    user_name    = each.value.user_name
  }
  provisioner "local-exec" {
    command = "bash '${path.module}/user.sh' create"
    environment = {
      AWS_REGION         = self.input.region
      DIRECTORY_ID       = self.input.directory_id
      EMAIL_ADDRESS      = each.value.email_address == null ? "" : each.value.email_address
      GIVEN_NAME         = each.value.given_name == null ? "" : each.value.given_name
      PASSWORD_SECRET_ID = module.password_secret.data[each.key].secret_arn
      SURNAME            = each.value.surname == null ? "" : each.value.surname
      USER_NAME          = self.input.user_name
    }
  }
  provisioner "local-exec" {
    command = "bash '${path.module}/user.sh' delete"
    environment = {
      AWS_REGION   = self.input.region
      DIRECTORY_ID = self.input.directory_id
      USER_NAME    = self.input.user_name
    }
    when = destroy
  }
  triggers_replace = [
    each.value.directory_id,
    each.value.user_name,
  ]
}
