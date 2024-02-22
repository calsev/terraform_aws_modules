locals {
  l0_map = {
    for k, v in var.key_map : k => v
  }
  l1_map = {
    for k, v in local.l0_map : k => merge(v, {
      algorithm   = v.algorithm == null ? var.key_algorithm_default : v.algorithm
      ecdsa_curve = v.ecdsa_curve == null ? var.key_ecdsa_curve_default : v.ecdsa_curve
      rsa_bits    = v.rsa_bits == null ? var.key_rsa_bits_default : v.rsa_bits
    })
  }
  l2_map = {
    for k, v in local.l0_map : k => {
    }
  }
  lx_map = {
    for k, v in local.l0_map : k => merge(local.l1_map[k], local.l2_map[k])
  }
  output_data = {
    for k, v in local.lx_map : k => merge(
      {
        for k_attr, v_attr in v : k_attr => v_attr if !contains([], k_attr)
      },
      {
        key_public_pem = tls_private_key.this_key[k].public_key_pem
      }
    )
  }
}
