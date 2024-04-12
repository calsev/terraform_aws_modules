resource "aws_iam_account_password_policy" "strict" {
  allow_users_to_change_password = var.allow_users_to_change_password
  hard_expiry                    = var.admin_reset_after_expiration
  max_password_age               = var.age_max_days
  minimum_password_length        = var.length_min
  password_reuse_prevention      = var.reuse_prevention_password_count
  require_lowercase_characters   = var.require_lowercase_character
  require_numbers                = var.require_number
  require_symbols                = var.require_symbol
  require_uppercase_characters   = var.require_uppercase_character
}
