resource "tls_private_key" "this_key" {
  for_each    = local.lx_map
  algorithm   = each.value.algorithm
  ecdsa_curve = each.value.ecdsa_curve
  rsa_bits    = each.value.rsa_bits
}
