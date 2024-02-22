output "data" {
  value = local.output_data
}

output "secret_map" {
  sensitive = true
  value = {
    for k, _ in local.lx_map : k => {
      key_private_pem = tls_private_key.this_key[k].private_key_pem
    }
  }
}
