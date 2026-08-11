output "data" {
  value = local.output_data
}

output "secret_map" {
  sensitive = true
  value = {
    for k, _ in local.lx_map : k => contains(keys(random_password.this_secret), k) ? random_password.this_secret[k].result : null
  }
}
