output "data" {
  value = local.output_data
}

output "secret_map" {
  value = merge(
    module.this_param.secret_map,
    module.this_secret.secret_map
  )
}
