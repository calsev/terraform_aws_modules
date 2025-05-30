terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"
    }
  }
  required_version = ">= 1.3"
}
