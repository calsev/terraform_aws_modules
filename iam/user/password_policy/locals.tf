locals {
  output_data = {
    allow_users_to_change_password  = var.allow_users_to_change_password
    admin_reset_after_expiration    = var.admin_reset_after_expiration
    age_max_days                    = var.age_max_days
    length_min                      = var.length_min
    require_lowercase_character     = var.require_lowercase_character
    require_number                  = var.require_number
    require_symbol                  = var.require_symbol
    require_uppercase_character     = var.require_uppercase_character
    reuse_prevention_password_count = var.reuse_prevention_password_count
  }
}
