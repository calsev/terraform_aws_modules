output "data" {
  value = local.output_data
}

output "secret_map" {
  value = module.initial_value.secret_map
}
