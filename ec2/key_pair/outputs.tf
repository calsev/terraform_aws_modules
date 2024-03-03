output "data" {
  value = local.output_data
}

output "secret_map" {
  value = module.key_secret.secret_map
}
